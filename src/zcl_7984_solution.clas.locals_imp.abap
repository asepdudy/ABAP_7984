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

CLASS lcl_passenger_flight DEFINITION .

  PUBLIC SECTION.

    DATA carrier_id    TYPE /dmo/carrier_id       READ-ONLY.
    DATA connection_id TYPE /dmo/connection_id    READ-ONLY.
    DATA flight_date   TYPE /dmo/flight_date      READ-ONLY.

    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
        i_flight_date   TYPE /dmo/flight_date.

    TYPES:
      BEGIN OF st_connection_details,
        airport_from_id TYPE /dmo/airport_from_id,
        airport_to_id   TYPE /dmo/airport_to_id,
        departure_time  TYPE /dmo/flight_departure_time,
        arrival_time    TYPE /dmo/flight_departure_time,
        duration        TYPE i,
      END OF st_connection_details.

    TYPES
      tt_flights TYPE STANDARD TABLE OF REF TO lcl_passenger_flight WITH DEFAULT KEY.

    METHODS: get_connection_details
      RETURNING
        VALUE(r_result) TYPE st_connection_details.

    METHODS
      get_free_seats
        RETURNING
          VALUE(r_result) TYPE i.

    METHODS
      get_description RETURNING VALUE(r_result) TYPE string_table.

    CLASS-METHODS
      get_flights_by_carrier
        IMPORTING
          i_carrier_id    TYPE /dmo/carrier_id
        RETURNING
          VALUE(r_result) TYPE tt_flights.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA planetype TYPE /dmo/plane_type_id.

    DATA seats_max  TYPE /dmo/plane_seats_max.
    DATA seats_occ  TYPE /dmo/plane_seats_occupied.
    DATA seats_free TYPE i.

    DATA price TYPE /dmo/flight_price.
    CONSTANTS currency TYPE /dmo/currency_code VALUE 'EUR'.


    DATA connection_details TYPE st_connection_details.

ENDCLASS.

CLASS lcl_passenger_flight IMPLEMENTATION.

  METHOD get_flights_by_carrier.

    SELECT
      FROM /lrn/passflight
    FIELDS carrier_id, connection_id, flight_date
     WHERE carrier_id    = @i_carrier_id
      INTO TABLE @DATA(keys).

    LOOP AT keys INTO DATA(key).
      APPEND NEW lcl_passenger_flight( i_carrier_id    = key-carrier_id
                                       i_connection_id = key-connection_id
                                       i_flight_date   = key-flight_date )
              TO r_result.
    ENDLOOP.

  ENDMETHOD.


  METHOD constructor.

    SELECT SINGLE
      FROM /lrn/passflight
    FIELDS plane_type_id, seats_max, seats_occupied, price, currency_code
     WHERE carrier_id    = @i_carrier_id
       AND connection_id = @i_connection_id
       AND flight_date   = @i_flight_date
      INTO @DATA(flight_raw).

    IF sy-subrc = 0.
      me->carrier_id    = i_carrier_id.
      me->connection_id = i_connection_id.
      me->flight_date   = i_flight_date.

      planetype = flight_raw-plane_type_id.
      seats_max = flight_raw-seats_max.
      seats_occ = flight_raw-seats_occupied.
      seats_free = flight_raw-seats_max - flight_raw-seats_occupied.

* convert currencies
      TRY.
          cl_exchange_rates=>convert_to_local_currency(
            EXPORTING
              date              = me->flight_date
              foreign_amount    = flight_raw-price
              foreign_currency  = flight_raw-currency_code
              local_currency    = me->currency
            IMPORTING
              local_amount      = me->price
          ).
        CATCH cx_exchange_rates.
          price = flight_raw-price.
      ENDTRY.

* Set connection details
      SELECT SINGLE
        FROM /dmo/connection
      FIELDS airport_from_id, airport_to_id, departure_time, arrival_time
       WHERE carrier_id    = @carrier_id
         AND connection_id = @connection_id
        INTO @connection_details .

      connection_details-duration = connection_details-arrival_time
                                  - connection_details-departure_time.

    ENDIF.
  ENDMETHOD.

  METHOD get_connection_details.
    r_result = me->connection_details.
  ENDMETHOD.


  METHOD get_free_seats.
    r_result = me->seats_free.
  ENDMETHOD.

  METHOD get_description.

    APPEND |Flight { carrier_id } { connection_id } on { flight_date DATE = USER } | &&
           |from { connection_details-airport_from_id } to { connection_details-airport_to_id } |
           TO r_result.
    APPEND |Planetype:      { planetype  } | TO r_result.
    APPEND |Maximum Seats:  { seats_max  } | TO r_result.
    APPEND |Occupied Seats: { seats_occ } | TO r_result.
    APPEND |Free Seats:     { seats_free } | TO r_result.
    APPEND |Ticket Price:   { price CURRENCY = currency } { currency } | TO r_result.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_cargo_flight DEFINITION .

  PUBLIC SECTION.

    TYPES: BEGIN OF st_connection_details,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             departure_time  TYPE /dmo/flight_departure_time,
             arrival_time    TYPE /dmo/flight_departure_time,
             duration        TYPE i,
           END OF st_connection_details.

    TYPES
       tt_flights TYPE STANDARD TABLE OF REF TO lcl_cargo_flight WITH DEFAULT KEY.

    DATA carrier_id    TYPE /dmo/connection_id    READ-ONLY.
    DATA connection_id TYPE /dmo/carrier_id       READ-ONLY.
    DATA flight_date   TYPE /dmo/flight_date      READ-ONLY.

    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
        i_flight_date   TYPE /dmo/flight_date.

    METHODS get_connection_details
      RETURNING
        VALUE(r_result) TYPE st_connection_details.

    METHODS
      get_free_capacity
        RETURNING
          VALUE(r_result) TYPE /lrn/plane_actual_load.

    METHODS get_description
      RETURNING
        VALUE(r_result) TYPE string_table.

    CLASS-METHODS
      get_flights_by_carrier
        IMPORTING
          i_carrier_id    TYPE /dmo/carrier_id
        RETURNING
          VALUE(r_result) TYPE tt_flights.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: BEGIN OF st_flights_buffer,
             carrier_id      TYPE /dmo/carrier_id,
             connection_id   TYPE /dmo/connection_id,
             flight_date     TYPE /dmo/flight_date,
             plane_type_id   TYPE /dmo/plane_type_id,
             maximum_load    TYPE /lrn/plane_maximum_load,
             actual_load     TYPE /lrn/plane_actual_load,
             load_unit       TYPE /lrn/plane_weight_unit,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             departure_time  TYPE /dmo/flight_departure_time,
             arrival_time    TYPE /dmo/flight_arrival_time,
           END OF st_flights_buffer.

    TYPES tt_flights_buffer TYPE HASHED TABLE OF st_flights_buffer
                            WITH UNIQUE KEY carrier_id connection_id flight_date.

    DATA connection_details TYPE st_connection_details.

    DATA planetype TYPE /dmo/plane_type_id.

    DATA maximum_load TYPE /lrn/plane_maximum_load.
    DATA actual_load TYPE /lrn/plane_actual_load.
    DATA load_unit    TYPE /lrn/plane_weight_unit.

    CLASS-DATA flights_buffer TYPE tt_flights_buffer.

ENDCLASS.

CLASS lcl_cargo_flight IMPLEMENTATION.

  METHOD get_flights_by_carrier.

    SELECT
      FROM /lrn/cargoflight
    FIELDS carrier_id, connection_id, flight_date,
           plane_type_id, maximum_load, actual_load, load_unit,
           airport_from_id, airport_to_id, departure_time, arrival_time
     WHERE carrier_id    = @i_carrier_id
      INTO CORRESPONDING FIELDS OF TABLE @flights_buffer.

    LOOP AT flights_buffer INTO DATA(flight).
      APPEND NEW lcl_cargo_flight( i_carrier_id    = flight-carrier_id
                                   i_connection_id = flight-connection_id
                                   i_flight_date   = flight-flight_date )
              TO r_result.

    ENDLOOP.
  ENDMETHOD.

  METHOD constructor.

    " Read buffer
    TRY.
        DATA(flight_raw) = flights_buffer[ carrier_id    = i_carrier_id
                                           connection_id = i_connection_id
                                           flight_date   = i_flight_date ].

      CATCH cx_sy_itab_line_not_found.
        " Read from database if data not found in buffer
        SELECT SINGLE
          FROM /lrn/cargoflight
        FIELDS plane_type_id, maximum_load, actual_load, load_unit,
               airport_from_id, airport_to_id, departure_time, arrival_time
         WHERE carrier_id    = @i_carrier_id
           AND connection_id = @i_connection_id
           AND flight_date   = @i_flight_date
          INTO CORRESPONDING FIELDS OF @flight_raw.
    ENDTRY.

    carrier_id    = i_carrier_id.
    connection_id = i_connection_id.
    flight_date   = i_flight_date.

    planetype = flight_raw-plane_type_id.
    maximum_load = flight_raw-maximum_load.
    actual_load = flight_raw-actual_load.
    load_unit = flight_raw-load_unit.

    connection_details = CORRESPONDING #( flight_raw ).

    connection_details-duration = me->connection_details-arrival_time
                                    - me->connection_details-departure_time.

  ENDMETHOD.


  METHOD get_connection_details.
    r_result = me->connection_details.
  ENDMETHOD.


  METHOD get_free_capacity.
    r_result = maximum_load - actual_load.
  ENDMETHOD.

  METHOD get_description.

    APPEND |Flight { carrier_id } { connection_id } on { flight_date DATE = USER } | &&
           |from { connection_details-airport_from_id } to { connection_details-airport_to_id } |
           TO r_result.
    APPEND |Planetype:     { planetype } |                         TO r_result.
    APPEND |Maximum Load:  { maximum_load         } { load_unit }| TO r_result.
    APPEND |Free Capacity: { get_free_capacity( ) } { load_unit }| TO r_result.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_carrier DEFINITION .

  PUBLIC SECTION.

    TYPES t_output TYPE c LENGTH 25.
    TYPES tt_output TYPE STANDARD TABLE OF t_output
                    WITH NON-UNIQUE DEFAULT KEY.

    DATA carrier_id TYPE /dmo/carrier_id READ-ONLY.

    METHODS constructor
      IMPORTING
                i_carrier_id TYPE /dmo/carrier_id
      RAISING   cx_abap_invalid_value.

    METHODS get_output RETURNING VALUE(r_result) TYPE tt_output.

    METHODS find_passenger_flight
      IMPORTING
        i_airport_from_id TYPE /dmo/airport_from_id
        i_airport_to_id   TYPE /dmo/airport_to_id
        i_from_date       TYPE /dmo/flight_date
        i_seats           TYPE i
      EXPORTING
        e_flight          TYPE REF TO lcl_passenger_flight
        e_days_later      TYPE i.

    METHODS find_cargo_flight
      IMPORTING
        i_airport_from_id TYPE /dmo/airport_from_id
        i_airport_to_id   TYPE /dmo/airport_to_id
        i_from_date       TYPE /dmo/flight_date
        i_cargo           TYPE /lrn/plane_actual_load
      EXPORTING
        e_flight          TYPE REF TO lcl_cargo_flight
        e_days_later      TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA name          TYPE /dmo/carrier_name .
    DATA currency_code TYPE /dmo/currency_code ##NEEDED.

    DATA passenger_flights TYPE lcl_passenger_flight=>tt_flights.

    DATA cargo_flights TYPE lcl_cargo_flight=>tt_flights.

    METHODS get_average_free_seats
      RETURNING VALUE(r_result) TYPE i.

ENDCLASS.

CLASS lcl_carrier IMPLEMENTATION.

  METHOD constructor.

    me->carrier_id = i_carrier_id.

    SELECT SINGLE
      FROM /dmo/carrier
    FIELDS name, currency_code
     WHERE carrier_id = @i_carrier_id
     INTO ( @me->name, @me->currency_code ).

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    name = carrier_id && ` ` && name.

    me->passenger_flights =
        lcl_passenger_flight=>get_flights_by_carrier(
              i_carrier_id    = i_carrier_id ).

    me->cargo_flights =
        lcl_cargo_flight=>get_flights_by_carrier(
              i_carrier_id    = i_carrier_id ).

  ENDMETHOD.

  METHOD get_output.

    APPEND |Carrier { me->name } | TO r_result.
    APPEND |Passenger Flights:  { lines( passenger_flights ) } | TO r_result.
    APPEND |Average free seats: { get_average_free_seats(  ) } | TO r_result.
    APPEND |Cargo Flights:      { lines( cargo_flights     ) } | TO r_result.

  ENDMETHOD.

  METHOD find_cargo_flight.

    e_days_later = 99999999.

    LOOP AT me->cargo_flights INTO DATA(flight)
        WHERE table_line->flight_date >= i_from_date.

      DATA(connection_details) = flight->get_connection_details(  ).

      IF connection_details-airport_from_id = i_airport_from_id
       AND connection_details-airport_to_id = i_airport_to_id
       AND flight->get_free_capacity(  ) >= i_cargo.

        DATA(days_later) = flight->flight_date - i_from_date.

        IF days_later < e_days_later. "earlier than previous one?
          e_flight = flight.
          e_days_later = days_later.
        ENDIF.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD find_passenger_flight.

    e_days_later = 99999999.

    LOOP AT me->passenger_flights INTO DATA(flight)
         WHERE table_line->flight_date >= i_from_date.

      DATA(connection_details) = flight->get_connection_details(  ).

      IF connection_details-airport_from_id = i_airport_from_id
       AND connection_details-airport_to_id = i_airport_to_id
       AND flight->get_free_seats( ) >= i_seats.
        DATA(days_later) = flight->flight_date - i_from_date.

        IF days_later < e_days_later. "earlier than previous one?
          e_flight = flight.
          e_days_later = days_later.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_average_free_seats.

    DATA total TYPE i.

    LOOP AT passenger_flights INTO DATA(flight).

      total = total + flight->get_free_seats( ).

    ENDLOOP.

    r_result = total / lines( passenger_flights ).

  ENDMETHOD.

ENDCLASS.
