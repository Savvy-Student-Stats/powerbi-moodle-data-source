// TimestampToDate (function)
// @since  2021-02-10
// @author code@sqrl.ca
//
// Convert a timestamp value in seconds since epoch to a date.
//
// @param timestamp {number} - Seconds since EPOCH (Jan 1, 1970)
// @return {date}
//
//
// @example    Grade        1610491503
// @example    Assignment   1612335540
//
// NOTE:
// Moodle uses seconds, NOT milliseconds, since epoch.
// This calculates on that. Often timesamps are milliseconds
// which require an additional operation to calculate.
// Bonus marks for figuring out that operation.
// // // // // // // // // // // // // // // // // // // //


// TimestampToDate =
(timestamp as number) =>
        let
        // DEFAULT_DATE = DateTime.Date(2019, 1, 1),
        // EPOCH_DATE = #datetime(1970, 1, 1, 0, 0, 0),

        dateValue =
            // Using try/otherwise to avoid `Error` values
            // when using a null timestamp or bad value.
            // Tried if/else but still had some errors occur.
            // Dataset is small enough this should be fast enough. :shrug:
            try
                DateTime.Date(
                    EPOCH_DATE + #duration(0, 0, 0, timestamp)
                )
            otherwise
                null
in
    returnValue


// http://excel-inside.pro/blog/2018/05/17/comparing-null-values-in-power-query/
