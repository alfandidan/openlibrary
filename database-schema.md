# Database Schema
| format | varchar |
| author_id | uuid |
| category_id | uuid |
| license_type | varchar |
| status | varchar |
| total_reads | integer |
| total_downloads | integer |
| created_at | timestamp |

---

# bookmarks

| Field | Type |
|---|---|
| id | uuid |
| user_id | uuid |
| book_id | uuid |
| page_number | integer |
| updated_at | timestamp |

---

# favorites

| Field | Type |
|---|---|
| id | uuid |
| user_id | uuid |
| book_id | uuid |
| created_at | timestamp |

---

# reading_history

| Field | Type |
|---|---|
| id | uuid |
| user_id | uuid |
| book_id | uuid |
| last_page | integer |
| progress | integer |
| updated_at | timestamp |

---

# reports

| Field | Type |
|---|---|
| id | uuid |
| reporter_id | uuid |
| book_id | uuid |
| reason | text |
| status | varchar |
| created_at | timestamp |