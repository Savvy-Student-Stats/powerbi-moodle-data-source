# Moodle

## Web Service Consumption Overview

1. `core_enrol_get_users_courses?userid=STUDENT_ID_HERE`
2. `mod_assign_get_assignments`
3. `gradereport_user_get_grade_items?userid=REPLACE&courseid=REPLACE`
4. `categories_something` *(optional)*


# Gotchas
## Courses and Grades Responses Differ
I tried abstracting `AskMoodleFor` to a single place.
I abstracted a bit too far.

The function is used by both `AskMoodleForCourses`
and `AskMoodleForGradebooks`.

After the call:

* `AskMoodleForCourses` / `core_enrol_get_users_courses`
  * Returns a `"List"`.
* `AskMoodleForGradebooks` / `gradereport_user_get_grade_items`
  * Returns:
    * `usergrades` as list
    * `warnings` as list

So the conversion just needs to happen in the source models.

