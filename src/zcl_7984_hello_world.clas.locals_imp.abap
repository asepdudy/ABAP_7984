*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_connection DEFINITION.

  PUBLIC SECTION.
    TYPES: BEGIN OF st_connection,
             connection_id   TYPE /dmo/connection_id,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             carrier_id      TYPE /dmo/carrier_id,
             carrier_name    TYPE /dmo/carrier_name,
           END OF st_connection.
    TYPES tt_connections TYPE SORTED TABLE OF st_connection
                              WITH UNIQUE KEY carrier_id
                                              connection_id.


    TYPES: BEGIN OF st_connection_nested,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             carrier_name    TYPE /dmo/carrier_name,
             message         TYPE symsg,
           END OF st_connection_nested.
    TYPES: BEGIN OF st_connection_short,
             DepartureAirport   TYPE /dmo/airport_from_id,
             DestinationAirport TYPE /dmo/airport_to_id,
           END OF st_connection_short.
    TYPES: BEGIN OF st_carrier,
             carrier_id    TYPE /dmo/carrier_id,
             carrier_name  TYPE /dmo/carrier_name,
             currency_code TYPE /dmo/currency_code,
           END OF st_carrier.

    TYPES tt_carriers TYPE STANDARD TABLE OF st_carrier
                          WITH NON-UNIQUE KEY carrier_id.


    TYPES: BEGIN OF st_airport,
             airportid TYPE /dmo/airport_id,
             name      TYPE /dmo/airport_name,
           END OF st_airport.
    TYPES tt_airports TYPE STANDARD TABLE OF st_airport
                          WITH NON-UNIQUE KEY airportid.





    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.
    DATA airport_from_id TYPE /dmo/airport_from_id.
    DATA airport_to_id   TYPE /dmo/airport_to_id.
    DATA carrier_name    TYPE /dmo/carrier_name.


*===============================================================================
* Internal table
    DATA connection_full TYPE /DMO/I_Connection. "CDS

    " standard table with non-unique standard key (short form)
    DATA connections_1 TYPE TABLE OF st_connection.


    " standard table with non-unique standard key (explicit form)
    DATA connections_2 TYPE STANDARD TABLE OF st_connection
                            WITH NON-UNIQUE DEFAULT KEY.
    DATA carriers TYPE tt_carriers.
    DATA carrier LIKE LINE OF  carriers.
    DATA connection_2 LIKE LINE OF connections_2.



    " sorted table with non-unique explicit key
    DATA connections_3  TYPE SORTED TABLE OF st_connection
                             WITH NON-UNIQUE KEY airport_from_id
                                                 airport_to_id.

    " sorted hashed with unique explicit key
    DATA connections_4  TYPE HASHED TABLE OF st_connection
                             WITH UNIQUE KEY carrier_id
                                             connection_id.

    " sorted table with non-unique explicit key
    DATA connections_5 TYPE tt_connections.

    DATA airports TYPE tt_airports.
    DATA airport_full TYPE /DMO/I_Airport.
    DATA airports_full TYPE STANDARD TABLE OF /DMO/I_Airport
                            WITH NON-UNIQUE KEY AirportID.




    DATA message TYPE symsg. "Global Structure
    DATA connection TYPE st_connection. "Custom Structure
    DATA connection_nested TYPE st_Connection_nested. "Custom Structure
    DATA connection_short TYPE st_connection_short. "Custom Structure
    CLASS-DATA conn_counter TYPE i READ-ONLY.

*===============================================================================
* EML
    DATA agencies_upd TYPE TABLE FOR UPDATE /DMO/I_AgencyTP.

    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
      RAISING
        cx_ABAP_INVALID_VALUE.

    METHODS set_attributes
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id  DEFAULT 'LH'
        i_Connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value.

    METHODS get_output
      RETURNING VALUE(r_output) TYPE string_table.

    METHODS access_standard.
    METHODS access_sorted.
    METHODS access_hashed.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA standard_table TYPE STANDARD TABLE OF zs4d401_flights WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
    DATA sorted_table TYPE SORTED TABLE OF zs4d401_flights WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
    DATA hashed_table TYPE HASHED TABLE OF zs4d401_flights WITH UNIQUE KEY carrier_id connection_id flight_date.


    DATA key_carrier_id TYPE /dmo/carrier_id.
    DATA key_connection_id TYPE /dmo/connection_id.
    DATA key_date TYPE /dmo/flight_date.
    METHODS set_line_to_read.

ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.
  METHOD constructor.

    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    me->connection_id = i_connection_id.
    me->carrier_id    = i_carrier_id.


    SELECT FROM zs4d401_flights FIELDS * INTO TABLE @standard_table.
    SELECT FROM zs4d401_flights FIELDS * INTO TABLE @sorted_table.
    SELECT FROM zs4d401_flights FIELDS * INTO TABLE @hashed_table.


    set_line_to_read( ).

    conn_counter = conn_counter + 1.

  ENDMETHOD.

*===============================================================================
  METHOD set_attributes.

    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    carrier_id    = i_carrier_id.
    connection_id = i_connection_id.

*===============================================================================
    IF 1 = 1. "Query ke table
      SELECT SINGLE
      FROM /dmo/connection
      FIELDS airport_from_id, airport_to_id
      WHERE carrier_id    = @i_carrier_id
         AND connection_id = @i_connection_id
      INTO ( @airport_from_id, @airport_to_id ).
    ENDIF.

*===============================================================================
    IF 1 = 1. "Query ke CDS put to DATA
      SELECT SINGLE
      FROM /DMO/I_Connection
      FIELDS DepartureAirport, DestinationAirport, \_Airline-Name
      WHERE AirlineID    = @i_carrier_id
      AND ConnectionID = @i_connection_id
      INTO ( @airport_from_id, @airport_to_id, @carrier_name ).
    ENDIF.

*===============================================================================
    IF 1 = 1. "Query ke CDS put to custom structure
      SELECT SINGLE
        FROM /DMO/I_Connection
      FIELDS ConnectionID, DepartureAirport, DestinationAirport, \_Airline-Name
       WHERE AirlineID = 'LH'
         AND ConnectionID = '0400'
        INTO @connection.

    ENDIF.

*===============================================================================
    IF 1 = 1. " Copy structure contain by Corresponding
      CLEAR connection_nested.
      connection_nested = CORRESPONDING #(  connection ).
    ENDIF.

*===============================================================================
    IF 1 = 1. "Query ke Full CDS put to Corresponding global structure
      SELECT SINGLE
      FROM /DMO/I_Connection
      FIELDS *
*      FIELDS AirlineID, ConnectionID, DepartureAirport, DestinationAirport,
*          DepartureTime, ArrivalTime, Distance, DistanceUnit
      WHERE AirlineID    = @i_carrier_id
      AND ConnectionID = @i_connection_id
      INTO CORRESPONDING FIELDS OF @connection_full.
    ENDIF.

*===============================================================================
    IF 1 = 1. "Query JOIN ke Full CDS put to dynamic variable
      SELECT SINGLE
        FROM (  /dmo/connection AS c
        LEFT OUTER JOIN /dmo/airport AS f
          ON c~airport_from_id = f~airport_id )
        LEFT OUTER JOIN /dmo/airport AS t
          ON c~airport_to_id = t~airport_id
      FIELDS c~airport_from_id, c~airport_to_id,
             f~name AS airport_from_name, t~name AS airport_to_name
       WHERE c~carrier_id    = 'LH'
         AND c~connection_id = '0400'
        INTO @DATA(connection_join).

    ENDIF.

*===============================================================================
    IF 1 = 1. " Internal Table Operation
      connection_2 = VALUE #( carrier_id       = 'NN'
                        connection_id    = '1234'
                        airport_from_id  = 'ABC'
                        airport_to_id    = 'XYZ'
                        carrier_name     = 'My Airline' ).

      APPEND connection_2 TO connections_2.

      APPEND VALUE #( carrier_id       = 'SQ'
                  connection_id    = '0001'
                  airport_from_id  = 'BCD'
                  airport_to_id    = 'YZZ'
                  carrier_name     = 'My Airline1'
                )
      TO connections_2.


      carriers = VALUE #(  (  carrier_id = 'AA' carrier_name = 'American Airlines' )
                        (  carrier_id = 'JL' carrier_name = 'Japan Airlines'    )
                        (  carrier_id = 'SQ' carrier_name = 'Singapore Airlines')
                     ).
      connections_2 = CORRESPONDING #( carriers ).


      CLEAR connection_2.
      connection_2 = connections_2[ carrier_id    = 'SQ'
                             connection_id = '0000' ].
      "kalo datanya ada > 1, maka yg di ambil yg pertama


      LOOP AT connections_2 INTO connection_2
                      WHERE airport_from_id <> 'MIA'.
        "do something with the content of connection
      ENDLOOP.


      carrier = carriers[  carrier_id = 'JL' ].
      carrier-currency_code = 'JPY'.
      MODIFY TABLE carriers FROM carrier.
      MODIFY carriers FROM carrier INDEX 1.


      LOOP AT carriers INTO carrier
                    WHERE currency_code IS INITIAL.
        carrier-currency_code = 'USD'.
        MODIFY carriers FROM carrier.

      ENDLOOP.


      SELECT SINGLE
        FROM /DMO/I_Airport
      FIELDS AirportID, Name, City, CountryCode
       WHERE City = 'Zurich'
        INTO @airport_full.


      SELECT
        FROM /DMO/I_Airport
      FIELDS airportid, Name, City, CountryCode
       WHERE City = 'London'
        INTO TABLE @airports_full.


      SELECT
      FROM /DMO/I_Airport
      FIELDS *
      WHERE City = 'London'
      INTO CORRESPONDING FIELDS OF TABLE @airports.


      SELECT
      FROM /DMO/I_airport
      FIELDS AirportID, Name AS AirportName
      WHERE City = 'London'
      INTO TABLE @DATA(airports_inline).


      SELECT FROM /DMO/I_Carrier
           FIELDS 'Airline' AS type, AirlineID AS Id, Name
           WHERE CurrencyCode = 'GBP'
      UNION ALL
      SELECT FROM /DMO/I_Airport
           FIELDS 'Airport' AS type, AirportID AS Id,  Name
           WHERE City = 'London'
      INTO TABLE @DATA(names).
    ENDIF.


*===============================================================================
    IF 1 = 1. " EML
      agencies_upd = VALUE #( ( agencyid = '070011' name = 'Some fancy new name' ) ).
      MODIFY ENTITIES OF /dmo/i_agencytp
      ENTITY /dmo/agency
      UPDATE FIELDS ( name )
        WITH agencies_upd.
      COMMIT ENTITIES.
    ENDIF.
  ENDMETHOD.

*===============================================================================
  METHOD get_output.

    APPEND |------------------------------| TO r_output.
    APPEND |Carrier:     { carrier_id    }| TO r_output.
    APPEND |Connection:  { connection_id }| TO r_output.
    APPEND |Departure:   { airport_from_id }|             TO r_output.
    APPEND |Destination: { airport_to_id   }|             TO r_output.
    APPEND |Carrier:     { carrier_id } { carrier_name }| TO r_output.
*    APPEND |connection_full:     { connection_full }| TO r_output.
    APPEND |AirlineID:        { connection_full-AirlineID }|        TO r_output.
    APPEND |ConnectionID:     { connection_full-ConnectionID }|     TO r_output.


  ENDMETHOD.


*===============================================================================

  METHOD access_hashed.
    DATA(result) = hashed_table[ carrier_Id = me->key_carrier_id connection_Id = me->key_connection_id flight_date = me->key_date ].
  ENDMETHOD.


  METHOD access_sorted.
    DATA(result) = sorted_table[ carrier_Id = me->key_carrier_id connection_Id = me->key_connection_id flight_date = me->key_date ].
  ENDMETHOD.

  METHOD set_line_to_read.
    DATA(line) = standard_table[ CONV i( lines( standard_table ) * '0.65' ) ].
    me->key_carrier_id = line-carrier_Id.
    me->key_connection_Id = line-connection_id.
    me->key_date = line-flight_date.


  ENDMETHOD.

  METHOD access_standard.
    DATA(result) = standard_table[ carrier_Id = me->key_carrier_id connection_Id = me->key_connection_id flight_date = me->key_date ].
  ENDMETHOD.
ENDCLASS.
