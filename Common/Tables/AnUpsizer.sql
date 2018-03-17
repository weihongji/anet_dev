--Getting indexes
select upper(t.name) as table_name, upper(i.name) as index_name, i.is_unique, ic.key_ordinal, upper(c.name) as column_name
from sys.tables t join sys.indexes i on i.object_id=t.object_id join sys.columns c on c.object_id=t.object_id join sys.index_columns ic on ic.index_id=i.index_id and ic.object_id=t.object_id and ic.column_id=c.column_id
where t.name<>'dtproperties' and i.is_primary_key=0
order by t.name, i.name, ic.key_ordinal