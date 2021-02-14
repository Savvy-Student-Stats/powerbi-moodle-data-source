// AddDateColumnsFromTimestamps (function)
// TimestampColumnsToDates (function)
//
// Convert a list of columns from Moodle timestamps
// to date fields. The new fields are added as `*_date`,
//
// Added column names will have `_date` appended to them (e.g. `myTimestamp_date`).
//
// @requires TimestampToDate (part of SchoolStats)
// @param SourceTable {table}
// @param colNames {list}
// @return {null} Adds `*_date` columns to `SourceTable`
//
// @since 2021-02-10


// ConvertTimestampColumns =
(SourceTable as table, colNames as list) =>
    let newSource = List.Accumulate(
        colNames,
        SourceTable,
        (state, colName) =>
            Table.AddColumn(
                state,
                colName & "_date",
                // "you can use the underscore „_“ to reference the current row of the table, which means the current record."
                each TimestampToDate(Record.Field(_, colName)),
                type date
            )
    )
in
    newSource
