CLASS zcl_7984_solution DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_7984_solution IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*===============================================================================
    IF 1 = 1. "TYPE
      TYPES gv_type TYPE p LENGTH 3 DECIMALS 2.
*    TYPES my_type TYPE i .
*    TYPES my_type TYPE string.
*    TYPES my_type TYPE n length 10.
      "=============================================================
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

      "=============================================================
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

      TYPES:
        BEGIN OF st_connections_buffer,
          carrier_id      TYPE /dmo/carrier_id,
          connection_id   TYPE /dmo/connection_id,
          airport_from_id TYPE /dmo/airport_from_id,
          airport_to_id   TYPE /dmo/airport_to_id,
          departure_time  TYPE /dmo/flight_departure_time,
          arrival_time    TYPE /dmo/flight_departure_time,
          timzone         TYPE /lrn/airport-timzone,
          duration        TYPE i,

        END OF st_connections_buffer.


      "=============================================================
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
               timzone   TYPE /lrn/airport-timzone,
             END OF st_airport.
      TYPES tt_airports TYPE STANDARD TABLE OF st_airport
                            WITH NON-UNIQUE KEY airportid.







    ENDIF.

*===============================================================================
    IF 1 = 1. "CONSTANTS
      CONSTANTS gc_text   TYPE string VALUE `Hello World `.
      CONSTANTS gc_char TYPE c LENGTH 1 VALUE '1'.
      CONSTANTS gc_carrier_id TYPE /dmo/carrier_id       VALUE 'LH'.
      CONSTANTS gc_connection_id TYPE /dmo/connection_id VALUE '0400'.
      CONSTANTS c_carrier_id TYPE /dmo/carrier_id VALUE 'LH'.
    ENDIF.
*===============================================================================
    IF 1 = 1. "DATA
      DATA gv_result TYPE i.
      DATA gv_numbers TYPE TABLE OF i.
      DATA gv_date  TYPE d                     VALUE '19891109'.
      DATA long_char TYPE c LENGTH 10.
      DATA short_char TYPE c LENGTH 5.
      DATA result TYPE p LENGTH 3 DECIMALS 2.
      DATA var_date TYPE d.
      DATA var_int TYPE i.
      DATA var_string TYPE string.
      DATA var_n TYPE n LENGTH 4.
      DATA timestamp1 TYPE utclong.
      DATA timestamp2 TYPE utclong.
      DATA difference TYPE decfloat34.
      DATA date_user TYPE d.
      DATA time_user TYPE t.
      DATA text   TYPE string VALUE `  Let's talk about ABAP  `.
      DATA result3 TYPE i.

*    DATA variable TYPE i.
*    DATA variable TYPE d.
*    DATA variable TYPE c LENGTH 10.
*    DATA variable TYPE n LENGTH 10.
*    DATA variable TYPE p LENGTH 8 DECIMALS 2.

      "====================================================================
      DATA gv_variable TYPE gv_type.

      DATA gv_airport TYPE /dmo/airport_id VALUE 'FRA'.
      DATA carrier_id    TYPE /dmo/carrier_id.
      DATA connection_id TYPE /dmo/connection_id.
      DATA airport_from_id TYPE /dmo/airport_from_id.
      DATA airport_to_id   TYPE /dmo/airport_to_id.
      DATA carrier_name    TYPE /dmo/carrier_name.
      DATA connection_full TYPE /DMO/I_Connection. "CDS
      DATA airport_full TYPE /DMO/I_Airport.

      "====================================================================
      DATA carriers TYPE tt_carriers.
      DATA carrier LIKE LINE OF  carriers.
      " sorted table with non-unique explicit key
      DATA connections_5 TYPE tt_connections.
      DATA message TYPE symsg. "Global Structure
      DATA connection TYPE st_connection. "Custom Structure
      DATA connection_nested TYPE st_Connection_nested. "Custom Structure
      DATA connection_short TYPE st_connection_short. "Custom Structure
      DATA airports TYPE tt_airports.

      DATA r_result TYPE TABLE OF string.
      DATA airports_full TYPE STANDARD TABLE OF /DMO/I_Airport
                              WITH NON-UNIQUE KEY AirportID.

      DATA connections_buffers TYPE TABLE OF st_connections_buffer.
      " standard table with non-unique standard key (short form)

      DATA connections_1 TYPE TABLE OF st_connection.
      " standard table with non-unique standard key (explicit form)
      DATA connections_2 TYPE STANDARD TABLE OF st_connection
                              WITH NON-UNIQUE DEFAULT KEY.
      DATA connection_2 LIKE LINE OF connections_2.
      " sorted table with non-unique explicit key
      DATA connections_3  TYPE SORTED TABLE OF st_connection
                               WITH NON-UNIQUE KEY airport_from_id
                                                   airport_to_id.
      " sorted hashed with unique explicit key
      DATA connections_4  TYPE HASHED TABLE OF st_connection
                               WITH UNIQUE KEY carrier_id
                                               connection_id.

      DATA gv_connection TYPE REF TO lcl_connection.
      DATA gv_connections  TYPE TABLE OF REF TO lcl_connection.



    ENDIF.

*===============================================================================
    IF 1 = 1. "out.write
      gv_result = 1.
      CLEAR gv_variable.
      out->write(  'Hello Worldas' ).
      DATA(lv_text) = gc_text && |ISO Date: { gv_date DATE = ISO  }|.
      out->write(   lv_text ).
    ENDIF.

*===============================================================================
    IF 1 = 1. "call Local Class set method
      TRY.
          gv_connection = NEW lcl_connection(
                           i_carrier_id    = 'LH'
                           i_connection_id = '0400'
                         ).

          gv_connection->set_attributes(
            EXPORTING
              i_carrier_id    = gc_carrier_id
              i_connection_id = gc_connection_id
          ).

          APPEND gv_connection TO gv_connections.
          out->write( `Method call successful` ).
        CATCH cx_abap_invalid_value.
          out->write( `Method call failed`     ).
      ENDTRY.
    ENDIF.

*===============================================================================
    IF 1 = 1. "call Local Class get method
      DATA(lv_string_table) = gv_connection->get_output( ).
      IF lv_string_table IS NOT INITIAL.
        LOOP AT lv_string_table INTO DATA(lw_string_table).
          out->write( lw_string_table ).
        ENDLOOP.
      ENDIF.

      out->write( 'connection: ' ).
      out->write( gv_connection->connection ).
      out->write( 'connection_nested: ' ).
      out->write( gv_connection->connection_nested ).
      out->write( 'connection_full: ' ).
      out->write( gv_connection->connection_full ).
      out->write(  `Example 2: Global Structured Type` ).
      out->write( gv_connection->message ).
    ENDIF.

*===============================================================================
    IF 1 = 1. "conversion data type


      long_char = 'ABCDEFGHIJ'.
      short_char = long_char.

      out->write( long_char ).
      out->write( short_char ).

      result = 1 / 8.
      out->write( |1 / 8 is rounded to { result NUMBER = USER }| ).





      var_date = cl_abap_context_info=>get_system_date( ).
      var_int = var_date.

      out->write( |Date as date| ).
      out->write( var_date ).
      out->write( |Date assigned to integer| ).
      out->write( var_int ).

      var_string = `R2D2`.
      var_n = var_string.

      out->write( |String| ).
      out->write( var_string ).
      out->write( |String assigned to type N| ).
      out->write( var_n ).

      DATA(result1) = '20230101'.
      out->write( result1 ).
      DATA(result2) = CONV d( '20230101' ).
      out->write( result2 ).
      TRY.
          result2 = EXACT #( '20221232' ).
        CATCH cx_sy_conversion_error.
          out->write( |2022-12-32 is not a valid date. EXACT triggered an exception| ).
      ENDTRY.

    ENDIF.

*===============================================================================
    IF 1 = 1. "date time


      timestamp1 = utclong_current( ).
      out->write( |Current UTC time { timestamp1 }| ).

      timestamp2 = utclong_add( val = timestamp1 days = 7 ).
      out->write( |Added 7 days to current UTC time { timestamp2 }| ).

      difference = utclong_diff( high = timestamp2 low = timestamp1 ).
      out->write( |Difference between timestamps in seconds: { difference }| ).

      out->write( |Difference between timestamps in days: { difference / 3600 / 24 }| ).

      CONVERT UTCLONG utclong_current( )
         INTO DATE date_user
              TIME time_user
              TIME ZONE cl_abap_context_info=>get_user_time_zone( ).

      out->write( |UTC timestamp split into date (type D) and time (type T )| ).
      out->write( |according to the user's time zone (cl_abap_context_info=>get_user_time_zone( ) ).| ).
      out->write( |{ date_user DATE = USER }, { time_user TIME = USER }| ).



      SELECT
      FROM /lrn/airport
      FIELDS airport_id, timzone
      INTO TABLE @airports.

      SELECT
        FROM /lrn/connection
        FIELDS carrier_id, connection_id,
               airport_from_id, airport_to_id, departure_time, arrival_time
        INTO TABLE @connections_buffers.
      DATA(today) = cl_abap_context_info=>get_system_date( ).

      LOOP AT connections_buffers INTO DATA(connection1).
        CONVERT DATE today
      TIME connection1-departure_time
      TIME ZONE airports[ airportid = connection1-airport_from_id ]-timzone
      INTO UTCLONG DATA(departure_utclong).

        CONVERT DATE today
          TIME connection1-arrival_time
          TIME ZONE airports[ airportid = connection1-airport_to_id ]-timzone
          INTO UTCLONG DATA(arrival_utclong).

        connection1-duration = utclong_diff(
                                high = arrival_utclong
                                low  = departure_utclong
                                           ) / 60.
        MODIFY connections_buffers FROM connection1 TRANSPORTING duration.
      ENDLOOP.




    ENDIF.

*===============================================================================
    IF 1 = 1. " text symbol

      APPEND |{ 'Carrier Name:'(001) } | TO r_result.
      LOOP AT r_result INTO DATA(lr_line).
        out->write( lr_line ).
      ENDLOOP.
    ENDIF.

*===============================================================================
    IF 1 = 1. " string functions


      out->write(  text ).

      result3 = find( val = text sub = 'A' ).
*    result3 = find( val = text sub = 'A' case = abap_false ).
*    result3 = find( val = text sub = 'A' case = abap_false occ =  -1 ).
*    result3 = find( val = text sub = 'A' case = abap_false occ =  -2 ).
*    result3 = find( val = text sub = 'A' case = abap_false occ =   2 ).
*    result3 = find( val = text sub = 'A' case = abap_false occ = 2 off = 10 ).
*    result3 = find( val = text sub = 'A' case = abap_false occ = 2 off = 10 len = 4 )
      out->write( |RESULT = { result3 } | ).

      DATA result4 TYPE i.

      DATA text1    TYPE string VALUE `  ABAP  `.
      DATA substring TYPE string VALUE `AB`.
      DATA offset    TYPE i      VALUE 1.

* Call different description functions
******************************************************************************
*    result4 = strlen(     text ).
*    result4 = numofchar(  text ).

      result4 = count(             val = text1 sub = substring off = offset ).
*    result4 = find(             val = text1 sub = substring off = offset ).

*    result4 = count_any_of(     val = text1 sub = substring off = offset ).
*    result4 = find_any_of(      val = text1 sub = substring off = offset ).

*    result4 = count_any_not_of( val = text1 sub = substring off = offset ).
*    result4 = find_any_not_of(  val = text1 sub = substring off = offset ).

      out->write( |Text      = `{ text1 }`| ).
      out->write( |Substring = `{ substring }` | ).
      out->write( |Offset    = { offset } | ).
      out->write( |Result    = { result4 } | ).

      text =  ` SAP BTP,   ABAP Environment  `.

* Change Case of characters
**********************************************************************
      out->write( |TO_UPPER         = {   to_upper(  text ) } | ).
      out->write( |TO_LOWER         = {   to_lower(  text ) } | ).
      out->write( |TO_MIXED         = {   to_mixed(  text ) } | ).
      out->write( |FROM_MIXED       = { from_mixed(  text ) } | ).


* Change order of characters
**********************************************************************
      out->write( |REVERSE             = {  reverse( text ) } | ).
      out->write( |SHIFT_LEFT  (places)= {  shift_left(  val = text places   = 3  ) } | ).
      out->write( |SHIFT_RIGHT (places)= {  shift_right( val = text places   = 3  ) } | ).
      out->write( |SHIFT_LEFT  (circ)  = {  shift_left(  val = text circular = 3  ) } | ).
      out->write( |SHIFT_RIGHT (circ)  = {  shift_right( val = text circular = 3  ) } | ).


* Extract a Substring
**********************************************************************
      out->write( |SUBSTRING       = {  substring(        val = text off = 4 len = 10 ) } | ).
      out->write( |SUBSTRING_FROM  = {  substring_from(   val = text sub = 'ABAP'     ) } | ).
      out->write( |SUBSTRING_AFTER = {  substring_after(  val = text sub = 'ABAP'     ) } | ).
      out->write( |SUBSTRING_TO    = {  substring_to(     val = text sub = 'ABAP'     ) } | ).
      out->write( |SUBSTRING_BEFORE= {  substring_before( val = text sub = 'ABAP'     ) } | ).


* Condense, REPEAT and Segment
**********************************************************************
      out->write( |CONDENSE         = {   condense( val = text ) } | ).
      out->write( |REPEAT           = {   repeat(   val = text occ = 2 ) } | ).

      out->write( |SEGMENT1         = {   segment(  val = text sep = ',' index = 1 ) } |  ).
      out->write( |SEGMENT2         = {   segment(  val = text sep = ',' index = 2 ) } |  ).
    ENDIF.


*===============================================================================
    IF 1 = 1. " open sql
      SELECT
  FROM /lrn/connection AS c
  LEFT OUTER JOIN /lrn/airport AS f
    ON c~airport_from_id = f~airport_id
  LEFT OUTER JOIN /lrn/airport AS t
    ON c~airport_to_id = t~airport_id
  FIELDS carrier_id, connection_id,
         airport_from_id, airport_to_id,
         departure_time, arrival_time
*         ,div(
*           tstmp_seconds_between(
*             tstmp1 = dats_tims_to_tstmp(
*                        date  = @today,
*                        time  = c~departure_time,
*                        tzone = f~timzone ),
*             tstmp2 = dats_tims_to_tstmp(
*                        date = @today,
*                        time = c~arrival_time,
*                        tzone = t~timzone )
*                                ),
*           60 ) AS duration
  INTO TABLE @connections_buffers.






      TRY.
          DATA(carrier1) = NEW lcl_carrier(  i_carrier_id = c_carrier_id ).

          out->write(  name = `Carrier Overview`
                       data = carrier1->get_output(  ) ).

        CATCH cx_abap_invalid_value.
          out->write( | Carrier { c_carrier_id } does not exist | ).
      ENDTRY.

      IF carrier1 IS BOUND.

        out->write(  `--------------------------------------------------` ).

* Find a passenger flight from Frankfurt to New York
* starting as soon as possible after tomorrow
* with at least 5 free seats

        today = cl_abap_context_info=>get_system_date(  ).

        carrier1->find_passenger_flight(
           EXPORTING
             i_airport_from_id = 'FRA'
             i_airport_to_id   = 'JFK'
             i_from_date       = today
             i_seats           = 5
           IMPORTING
             e_flight =     DATA(pass_flight)
             e_days_later = DATA(days_later)
                           ).

        IF pass_flight IS BOUND.
          out->write( name = |Found a suitable passenger flight in { days_later } days:|
                      data = pass_flight->get_description( ) ).
        ELSE.
          out->write( data = `No Passenger Flight found` ).
        ENDIF.

        out->write(  `--------------------------------------------------` ).

** Find a cargo flight from Frankfurt to New York
** starting as soon as possible but earliest in 7 days
** with at least 1200 KG free capacity
*
        carrier1->find_cargo_flight(
           EXPORTING
             i_airport_from_id = 'FRA'
             i_airport_to_id   = 'JFK'
             i_from_date       = today
             i_cargo           = 1200
           IMPORTING
             e_flight =     DATA(cargo_flight)
             e_days_later = DATA(days_later2)
                           ).

        IF cargo_flight IS BOUND.
          out->write( name = |Found a suitable cargo flight in { days_later2 } days:|
                      data = cargo_flight->get_description( ) ).
        ELSE.
          out->write( data = `No cargo flight found` ).
        ENDIF.


      ENDIF.
    ENDIF.

*===============================================================================
    IF 1 = 1. " CDS authorization
*      CONSTANTS c_carrier_id TYPE /dmo/carrier_id VALUE 'UA'.
      TRY.
          AUTHORITY-CHECK
            OBJECT '/LRN/CARR'
              ID '/LRN/CARR' FIELD c_carrier_id
              ID 'ACTVT'     FIELD '03'.

          IF sy-subrc <> 0.
            RAISE EXCEPTION TYPE cx_abap_auth_check_exception.
          ENDIF.


          DATA(carrier2) = NEW lcl_carrier( i_carrier_id = c_carrier_id ).
          out->write( name = `Carrier Overview`
                      data = carrier2->get_output(  ) ).
        CATCH cx_abap_invalid_value.
          out->write( |Carrier { c_carrier_id } does not exist| ).
        CATCH cx_abap_auth_check_exception.
          out->write( |No authorization to display carrier { c_carrier_id }| ).
      ENDTRY.



*      SELECT SINGLE
* FROM /lrn/carrier
* FIELDS concat_with_space( carrier_id, name, 1 ), currency_code
* WHERE carrier_id = @c_carrier_id
* INTO ( @me->name, @me->currency_code ).


    ENDIF.

  ENDMETHOD.
ENDCLASS.
