CLASS lhc_zr_7984flight DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Zr7984flight
        RESULT result,
      validatePrice FOR VALIDATE ON SAVE
        IMPORTING keys FOR Zr7984flight~validatePrice.
ENDCLASS.

CLASS lhc_zr_7984flight IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD validatePrice.
    DATA failed_record   LIKE LINE OF failed-zr7984flight.
    DATA reported_record LIKE LINE OF reported-zr7984flight.

    READ ENTITIES OF ZR_7984Flight IN LOCAL MODE
    ENTITY Zr7984flight
    FIELDS ( Price )
    WITH CORRESPONDING #(  keys )
    RESULT DATA(flights).

    LOOP AT flights INTO DATA(flight).
      IF flight-price <= 0.

        failed_record-%tky = flight-%tky.
        APPEND failed_record TO failed-zr7984flight.

        reported_record-%tky = flight-%tky.
        reported_record-%msg = new_message(
                      id       = '/LRN/S4D400'
                      number   = '101'
                      severity = ms-error ).
        APPEND reported_record TO reported-zr7984flight.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
