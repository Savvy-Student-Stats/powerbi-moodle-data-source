// AskMoodleForGradebook.dax
// @since 2021-02-10
(courseid as number) =>
    let
        Source = AskMoodleFor(
            "gradereport_user_get_grade_items", "userid=10335&courseid="
            & Number.ToText(courseid)),
        Grades = Source
in
    Source

