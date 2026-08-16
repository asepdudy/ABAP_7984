@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'Z7984CONN'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_7984CONN
  provider contract transactional_query
  as projection on ZR_7984CONN
  association [1..1] to ZR_7984CONN as _BaseEntity on $projection.UUID = _BaseEntity.UUID
{
  key UUID,
      CarrierID,
      ConnectionID,
      AirportFrom,
      CityFrom,
      AirportTo,
      CityTo,
      CountryTo,
      @Semantics: {
        user.createdBy: true
      }
      LocalCreatedBy,
      @Semantics: {
        systemDateTime.createdAt: true
      }
      LocalCreatedAt,
      @Semantics: {
        user.localInstanceLastChangedBy: true
      }
      LocalLastChangedBy,
      @Semantics: {
        systemDateTime.localInstanceLastChangedAt: true
      }
      LocalLastChangedAt,
      @Semantics: {
        systemDateTime.lastChangedAt: true
      }
      LastChangedAt,
      _BaseEntity
}
