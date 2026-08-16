@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'Z7984CONN'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_7984CONN
  as select from Z7984CONN
{
  key uuid as UUID,
  carrier_id as CarrierID,
  connection_id as ConnectionID,
  airport_from as AirportFrom,
  city_from as CityFrom,
  airport_to as AirportTo,
  city_to as CityTo,
  country_to as CountryTo,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
