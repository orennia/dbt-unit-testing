select * from {{ dbt_unit_testing.ref('model-with-dashes') }}