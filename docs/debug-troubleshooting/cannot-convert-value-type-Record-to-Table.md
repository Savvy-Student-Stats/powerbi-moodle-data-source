


```dax
// Gradebooks.dax
// @since 2021-0

let
    COURSE_IDS = { 780,671,673,684,702 },

    SourceTable = [],

    // List.Accumulate(
    //     COURSE_IDS,
    //     Gradebooks,
    //     (state, )
    //         Table.
    // )
    Course1 = AskMoodleForGradebook(780),
    Course2 = AskMoodleForGradebook(671),
    Result = Table.Combine({
        Course1,
        Course2
    })
    // course3 = AskMoodleForGradebook(),
    // course4 = AskMoodleForGradebook(),
in
    Result

```
