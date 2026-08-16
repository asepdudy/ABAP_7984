"!@testing ZC_7984CONN
CLASS ltc_zc_7984conn DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA environment TYPE REF TO if_cds_test_environment.

    DATA td_zr_7984conn TYPE STANDARD TABLE OF zr_7984conn WITH EMPTY KEY.
    DATA act_results TYPE STANDARD TABLE OF zc_7984conn WITH EMPTY KEY.
    DATA exp_results TYPE STANDARD TABLE OF zc_7984conn WITH EMPTY KEY.

    "! In CLASS_SETUP, corresponding doubles and clone(s) for the CDS view under test and its dependencies are created.
    CLASS-METHODS class_setup RAISING cx_static_check.
    "! In CLASS_TEARDOWN, Generated database entities (doubles & clones) should be deleted at the end of test class execution.
    CLASS-METHODS class_teardown.

    "! SETUP method creates a common start state for each test method,
    "! clear_doubles clears the test data for all the doubles used in the test method before each test method execution.
    METHODS setup RAISING cx_static_check.

    "! In this method test data is inserted into the generated double(s) for test case
    "! "Test CDS with DCL ZC_7984CONN disabled"
    METHODS td_dcl_1_disabled_access_contr.
    "! In this method test data is inserted into the generated double(s) for test case
    "! "Test CDS with DCL ZC_7984CONN double, when user has no authorizations"
    METHODS td_dcl_1_no_auth.
    "! In this method test data is inserted into the generated double(s) for test case
    "! "Test CDS with DCL ZC_7984CONN double, when user has partial authorizations"
    METHODS td_dcl_1_partial_auths.
    "! In this method test data is inserted into the generated double(s) for test case
    "! "Test CDS with DCL ZC_7984CONN double, when user has all needed authorizations"
    METHODS td_dcl_1_all_required_auths.

    "! <strong>Test Case:</strong> Test CDS with DCL ZC_7984CONN disabled <br><br>
    "! Test CDS with DCL being disabled. Note: All other conditions in CDS should be met and user also has
    "!  authorizations for other acting DCLs
    "! <br><br> The results should be asserted with the actuals.
    METHODS dcl_1_disabled_access_control FOR TESTING RAISING cx_static_check.
    "! <strong>Test Case:</strong> Test CDS with DCL ZC_7984CONN double, when user has no authorizations <br><br>
    "! Test CDS when user has none of the required authorizations for the DCL. Note: All other conditions
    "!  in CDS should be met and user also has authorizations for other acting DCLs
    "! <br><br> The results should be asserted with the actuals.
    METHODS dcl_1_no_auth FOR TESTING RAISING cx_static_check.
    "! <strong>Test Case:</strong> Test CDS with DCL ZC_7984CONN double, when user has partial authorizations <br><br>
    "! Test CDS when user has partial required authorizations for the DCL. Note: All other conditions in
    "!  CDS should be met and user also has authorizations for other acting DCLs
    "! <br><br> The results should be asserted with the actuals.
    METHODS dcl_1_partial_auths FOR TESTING RAISING cx_static_check.
    "! <strong>Test Case:</strong> Test CDS with DCL ZC_7984CONN double, when user has all needed authorizations <br><br>
    "! Test CDS with all required authorizations for the DCL. Note: All other conditions in CDS should be
    "!  met and user also has authorizations for other acting DCLs
    "! <br><br> The results should be asserted with the actuals.
    METHODS dcl_1_all_required_auths FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_ZC_7984CONN IMPLEMENTATION.

  METHOD class_setup.
    environment = cl_cds_test_environment=>create( i_for_entity = 'ZC_7984CONN' ).
  ENDMETHOD.

  METHOD setup.
    environment->clear_doubles( ).
  ENDMETHOD.

  METHOD class_teardown.
    environment->destroy( ).
  ENDMETHOD.

  METHOD dcl_1_disabled_access_control.
    td_dcl_1_disabled_access_contr( ).
    SELECT * FROM zc_7984conn INTO TABLE @act_results.

    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
  ENDMETHOD.

  METHOD td_dcl_1_disabled_access_contr.
    " Prepare test data for 'zr_7984conn'
    td_zr_7984conn = VALUE #(
      (
        uuid = '0123456789ABCDEF0123456789ABCDEF'
        carrierid = 'LH'
        connectionid = '0001'
        airportfrom = 'FRA'
        cityfrom = 'Frankfurt'
        airportto = 'JFK'
        cityto = 'New York'
        countryto = 'USA'
        localcreatedby = 'USER1'
        localcreatedat = '20240101120000'
        locallastchangedby = 'USER2'
        locallastchangedat = '20240102130000'
        lastchangedat = '20240103140000'
      ) ).
    environment->insert_test_data( i_data = td_zr_7984conn ).

    " Prepare test data for 'zc_7984conn'
    exp_results = VALUE #(
      (
           uuid = '0123456789ABCDEF0123456789ABCDEF'
           carrierid = 'LH'
           connectionid = '0001'
           airportfrom = 'FRA'
           cityfrom = 'Frankfurt'
           airportto = 'JFK'
           cityto = 'New York'
           countryto = 'USA'
           localcreatedby = 'USER1'
           localcreatedat = '20240101120000'
           locallastchangedby = 'USER2'
           locallastchangedat = '20240102130000'
           lastchangedat = '20240103140000'
      ) ).
  ENDMETHOD.

  METHOD dcl_1_no_auth.
    td_dcl_1_no_auth( ).
    SELECT * FROM zc_7984conn INTO TABLE @act_results.

    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
  ENDMETHOD.

  METHOD td_dcl_1_no_auth.
    " Prepare test data for 'zr_7984conn'
    td_zr_7984conn = VALUE #(
      (
        uuid = '0123456789ABCDEF0123456789ABCDEF'
        carrierid = 'LH'
        connectionid = '0001'
        airportfrom = 'FRA'
        cityfrom = 'Frankfurt'
        airportto = 'JFK'
        cityto = 'New York'
        countryto = 'USA'
        localcreatedby = 'USER123'
        localcreatedat = '20240101120000'
        locallastchangedby = 'USER123'
        locallastchangedat = '20240102130000'
        lastchangedat = '20240102130000'
      ) ).
    environment->insert_test_data( i_data = td_zr_7984conn ).


  ENDMETHOD.

  METHOD dcl_1_partial_auths.
    td_dcl_1_partial_auths( ).
    SELECT * FROM zc_7984conn INTO TABLE @act_results.

    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
  ENDMETHOD.

  METHOD td_dcl_1_partial_auths.
    " Prepare test data for 'zr_7984conn'
    td_zr_7984conn = VALUE #(
      (
        uuid = '0123456789ABCDEF0123456789ABCDEF'
        carrierid = 'LH'
        connectionid = '1001'
        airportfrom = 'FRA'
        cityfrom = 'Frankfurt'
        airportto = 'JFK'
        cityto = 'New York'
        countryto = 'USA'
        localcreatedby = 'USER_PARTIAL'
        localcreatedat = '20240610120000'
        locallastchangedby = 'USER_PARTIAL'
        locallastchangedat = '20240610130000'
        lastchangedat = '20240610140000'
      )
      (
        uuid = 'FEDCBA9876543210FEDCBA9876543210'
        carrierid = 'LH'
        connectionid = '1002'
        airportfrom = 'FRA'
        cityfrom = 'Frankfurt'
        airportto = 'LHR'
        cityto = 'London'
        countryto = 'GBR'
        localcreatedby = 'USER_FULL'
        localcreatedat = '20240610121000'
        locallastchangedby = 'USER_FULL'
        locallastchangedat = '20240610131000'
        lastchangedat = '20240610141000'
      ) ).
    environment->insert_test_data( i_data = td_zr_7984conn ).

    " Prepare test data for 'zc_7984conn'
    exp_results = VALUE #(
      (
           uuid = 'FEDCBA9876543210FEDCBA9876543210'
           carrierid = 'LH'
           connectionid = '1002'
           airportfrom = 'FRA'
           cityfrom = 'Frankfurt'
           airportto = 'LHR'
           cityto = 'London'
           countryto = 'GBR'
           localcreatedby = 'USER_FULL'
           localcreatedat = '20240610121000'
           locallastchangedby = 'USER_FULL'
           locallastchangedat = '20240610131000'
           lastchangedat = '20240610141000'
      ) ).
  ENDMETHOD.

  METHOD dcl_1_all_required_auths.
    td_dcl_1_all_required_auths( ).
    SELECT * FROM zc_7984conn INTO TABLE @act_results.

    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
  ENDMETHOD.

  METHOD td_dcl_1_all_required_auths.
    " Prepare test data for 'zr_7984conn'
    td_zr_7984conn = VALUE #(
      (
        uuid = '0123456789ABCDEF0123456789ABCDEF'
        carrierid = 'LH'
        connectionid = '1234'
        airportfrom = 'FRA'
        cityfrom = 'Frankfurt'
        airportto = 'JFK'
        cityto = 'New York'
        countryto = 'USA'
        localcreatedby = 'USER123456'
        localcreatedat = '20240610120000'
        locallastchangedby = 'USER123456'
        locallastchangedat = '20240610123000'
        lastchangedat = '20240610123000'
      ) ).
    environment->insert_test_data( i_data = td_zr_7984conn ).

    " Prepare test data for 'zc_7984conn'
    exp_results = VALUE #(
      (
           uuid = '0123456789ABCDEF0123456789ABCDEF'
           carrierid = 'LH'
           connectionid = '1234'
           airportfrom = 'FRA'
           cityfrom = 'Frankfurt'
           airportto = 'JFK'
           cityto = 'New York'
           countryto = 'USA'
           localcreatedby = 'USER123456'
           localcreatedat = '20240610120000'
           locallastchangedby = 'USER123456'
           locallastchangedat = '20240610123000'
           lastchangedat = '20240610123000'
      ) ).
  ENDMETHOD.

ENDCLASS.
