# API Flow

# Authentication Flow

## Register
1. User submits registration form.
2. Backend validates data.
3. User account created.
4. Verification email sent.
5. User logged in.

---

## Login
1. User enters credentials.
2. Backend validates credentials.
3. JWT/session returned.
4. User redirected to home.

---

# Book Upload Flow

1. Author uploads cover image.
2. Author uploads EPUB/PDF.
3. Metadata validated.
4. Files stored in cloud storage.
5. Book status set to pending.
6. Admin reviews submission.
7. Book published.

---

# Reading Flow

1. User opens book.
2. App loads reader.
3. Reading progress saved automatically.
4. Bookmarks synced to database.

---

# Search Flow

1. User enters keyword.
2. Backend searches books table.
3. Results sorted by relevance.
4. Paginated results returned.

---

# Report System

1. User reports book.
2. Report stored.
3. Admin notified.
4. Admin reviews report.
5. Action taken.