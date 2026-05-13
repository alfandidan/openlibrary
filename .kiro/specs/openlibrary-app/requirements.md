# Requirements Document

## Introduction

This document defines the requirements for the OpenLibrary App — a cross-platform Flutter mobile application (Android and iOS) that allows users to discover, read, and manage books sourced from the Open Library API and user-uploaded content. The App provides EPUB/PDF reading capabilities, personal library management, and a community-driven book upload system.

The App is built using Clean Architecture with the Repository Pattern and a feature-based folder structure. State management uses Riverpod or Bloc. The backend is powered by Supabase, providing authentication, a PostgreSQL database (with tables for books, bookmarks, favorites, reading_history, and reports), and cloud file storage. The development roadmap prioritizes Phase 1 (core reading application) covering project setup, authentication, home page, book listing, book detail, EPUB/PDF readers, the upload system, and basic admin moderation.

## Glossary

- **App**: The OpenLibrary Flutter mobile application
- **User**: An authenticated person using the App to read or manage books
- **Author**: A User who uploads and manages books on the platform
- **Admin**: A privileged User who moderates content and manages the platform
- **Book**: A digital publication (EPUB or PDF) with associated metadata
- **Reader**: The in-app component that renders EPUB or PDF content for reading
- **Library**: A User's personal collection of favorited and bookmarked books
- **Open_Library_API**: The external Open Library API (openlibrary.org) used for book discovery and metadata
- **Supabase_Backend**: The Supabase instance providing authentication, database, and storage services
- **Book_Repository**: The data layer responsible for fetching and caching book data
- **Auth_Service**: The service handling user authentication and session management
- **Search_Engine**: The component responsible for querying books by keyword, author, or category
- **Progress_Tracker**: The component that tracks and syncs reading progress across sessions
- **Upload_Service**: The service handling book file uploads and metadata submission
- **Moderation_Queue**: The system where uploaded books await Admin approval

## Requirements

### Requirement 1: User Authentication

**User Story:** As a User, I want to register and log in to the App, so that I can access personalized features like reading progress, favorites, and bookmarks.

#### Acceptance Criteria

1. WHEN a User submits a registration form with a valid email address and a password of at least 8 characters containing at least one uppercase letter, one lowercase letter, and one digit, THE Auth_Service SHALL create a new account and send a verification email to the provided address
2. IF a User submits a registration form with an email address that is already associated with an existing account, THEN THE Auth_Service SHALL reject the registration and display an error message indicating the email is already in use
3. WHEN a User submits valid login credentials, THE Auth_Service SHALL return a session token with a maximum lifetime of 7 days and navigate the User to the home screen
4. IF a User submits invalid credentials, THEN THE Auth_Service SHALL display a generic error message indicating that the email or password is incorrect, without revealing which field is wrong
5. IF a User fails to authenticate 5 consecutive times for the same account, THEN THE Auth_Service SHALL temporarily lock login attempts for that account for 15 minutes
6. WHEN a User requests a password reset, THE Auth_Service SHALL send a password reset link to the registered email that expires after 60 minutes
7. IF a User requests a password reset with an email not associated with any account, THEN THE Auth_Service SHALL display the same confirmation message as a successful request without revealing whether the email exists
8. WHILE a User session is active and the session token has not exceeded its 7-day lifetime, THE App SHALL maintain the authenticated state across app restarts
9. WHEN a User taps the logout button, THE Auth_Service SHALL invalidate the session token and navigate to the login screen

### Requirement 2: Book Discovery and Search

**User Story:** As a User, I want to search and browse books, so that I can find content I want to read.

#### Acceptance Criteria

1. WHEN the App launches with an authenticated User, THE App SHALL display a home screen with up to 10 featured books, a list of categories, and up to 20 recently added books
2. WHEN a User enters a search query of at least 1 character, THE Search_Engine SHALL return results matching the query against book titles, authors, and descriptions, paginated in groups of 20 results per page
3. WHEN a User selects a category, THE Book_Repository SHALL return books filtered by that category, paginated in groups of 20 results per page
4. WHEN a User taps on a book card, THE App SHALL navigate to a book detail screen showing title, author, cover image, description, format, and read count
5. WHILE search results are loading, THE App SHALL display a loading indicator
6. IF the Open_Library_API returns an error, THEN THE App SHALL display a non-technical error message indicating the service is temporarily unavailable and offer a retry option
7. IF a search query or category filter returns no results, THEN THE App SHALL display an empty state message indicating no books were found and suggest modifying the search terms

### Requirement 3: Book Reading (EPUB)

**User Story:** As a User, I want to read EPUB books within the App, so that I can enjoy a comfortable reading experience without leaving the application.

#### Acceptance Criteria

1. WHEN a User opens an EPUB book, THE Reader SHALL display a loading indicator and render the book content preserving paragraph structure, headings, inline styles, embedded images, and chapter boundaries within 10 seconds
2. WHILE a User is reading, THE Reader SHALL allow font size adjustment between 12px and 32px in 2px increments, defaulting to 16px
3. WHILE a User is reading, THE Reader SHALL support light, dark, and sepia color themes, applying the selected theme immediately to all rendered content
4. WHEN a User navigates to a different page, THE Progress_Tracker SHALL save the current page position within 2 seconds
5. WHEN a User reopens a previously read book, THE Reader SHALL restore the last reading position; IF the saved position cannot be restored, THEN THE Reader SHALL open the book at the beginning and display a notification indicating the position was reset
6. WHEN a User taps the table of contents button, THE Reader SHALL display a navigable list of chapters extracted from the EPUB's table of contents metadata
7. WHILE a User is reading, THE Reader SHALL support horizontal swipe and vertical scroll navigation modes, with horizontal swipe as the default mode
8. IF an EPUB file fails to load or is corrupted, THEN THE Reader SHALL display an error message indicating the book cannot be opened and navigate the User back to the previous screen

### Requirement 4: Book Reading (PDF)

**User Story:** As a User, I want to read PDF books within the App, so that I can access PDF-format content seamlessly.

#### Acceptance Criteria

1. WHEN a User opens a PDF book, THE Reader SHALL render all pages preserving the original page dimensions, embedded fonts, images, and vector graphics as defined in the PDF document
2. WHILE a User is reading a PDF, THE Reader SHALL support pinch-to-zoom gestures with a zoom range of 1x (fit-to-width) to 5x magnification
3. WHEN a User navigates to a different page in a PDF, THE Progress_Tracker SHALL save the current page number within 2 seconds
4. WHEN a User reopens a previously read PDF, THE Reader SHALL restore the last saved page position within 3 seconds of opening the book
5. WHILE a User is reading a PDF, THE Reader SHALL display the current page number and total page count in the format "page X of Y"
6. WHILE a User is reading a PDF, THE Reader SHALL support page navigation via horizontal swipe gestures and a page number input field for direct page access
7. IF a PDF file fails to load or is corrupted, THEN THE Reader SHALL display an error message indicating the file cannot be opened and navigate the User back to the book detail screen

### Requirement 5: Reading Progress Synchronization

**User Story:** As a User, I want my reading progress to sync across sessions, so that I can continue reading from where I left off on any device.

#### Acceptance Criteria

1. WHEN a User navigates to a new page in the reader, THE Progress_Tracker SHALL persist the book ID, last page number, and percentage progress (as an integer from 0 to 100) to the Supabase_Backend within 5 seconds of the page change
2. WHEN a User opens a book that has existing reading history in the Supabase_Backend, THE Progress_Tracker SHALL fetch the latest reading position and resume from the stored last page number
3. WHEN a User opens a book that has no existing reading history in the Supabase_Backend, THE Progress_Tracker SHALL start from page 1 and create a new reading history record with progress set to 0
4. IF the network is unavailable when a position change occurs, THEN THE Progress_Tracker SHALL cache the progress locally and automatically sync to the Supabase_Backend within 30 seconds of connectivity being restored
5. IF the locally cached progress and the Supabase_Backend progress conflict during sync, THEN THE Progress_Tracker SHALL retain the record with the most recent updated_at timestamp
6. IF a sync attempt to the Supabase_Backend fails after 3 retry attempts, THEN THE Progress_Tracker SHALL retain the local cache and display an indicator to the User that progress is not yet synced

### Requirement 6: Personal Library Management

**User Story:** As a User, I want to manage my personal library with favorites and bookmarks, so that I can organize and quickly access books I care about.

#### Acceptance Criteria

1. WHEN a User taps the favorite button on a book, THE App SHALL add the book to the User's favorites list, persist the change to the Supabase_Backend, and display the favorite button in its active state
2. WHEN a User taps the favorite button on an already-favorited book, THE App SHALL remove the book from the User's favorites list, persist the removal to the Supabase_Backend, and display the favorite button in its inactive state
3. WHEN a User creates a bookmark while reading, THE App SHALL save the bookmark with the book ID and page number to the Supabase_Backend, up to a maximum of 50 bookmarks per book
4. WHEN a User navigates to the Library screen, THE App SHALL display tabs for favorites, bookmarks, and reading history, each showing items sorted by most recently added first
5. WHEN a User taps a bookmarked entry, THE Reader SHALL open the book at the bookmarked page
6. WHEN a User deletes a bookmark, THE App SHALL remove the bookmark from the Supabase_Backend and remove it from the displayed list
7. IF the Supabase_Backend is unavailable when a User performs a favorite or bookmark action, THEN THE App SHALL display an error message indicating the action could not be completed and preserve the previous state

### Requirement 7: Book Upload

**User Story:** As an Author, I want to upload books to the platform, so that I can share my work with readers.

#### Acceptance Criteria

1. WHEN an Author submits a book upload form, THE Upload_Service SHALL validate that a cover image (JPEG or PNG, maximum 5MB), book file (EPUB or PDF), title (1 to 200 characters), description (1 to 5000 characters), category, and license type are provided
2. IF any required field is missing or fails validation, THEN THE Upload_Service SHALL reject the submission and display an error message indicating which fields are invalid
3. WHEN all required fields are valid, THE Upload_Service SHALL upload the cover image and book file to Supabase storage and create a book record with status "pending"
4. IF a book file exceeds 50MB, THEN THE Upload_Service SHALL reject the upload and display a file size error
5. WHILE an upload is in progress, THE App SHALL display upload progress as a percentage (0 to 100)
6. WHEN an upload completes successfully, THE App SHALL notify the Author that the book is pending review
7. THE Upload_Service SHALL accept EPUB and PDF book file formats only
8. WHEN an Author fills the upload form, THE App SHALL allow adding up to 10 tags (each tag 1 to 30 characters) to the book for improved discoverability
9. THE Upload_Service SHALL require the Author to select a license type from predefined options (Creative Commons, Public Domain, Custom)
10. IF the upload fails due to a network or storage error, THEN THE App SHALL display an error message indicating the failure and allow the Author to retry without re-entering form data

### Requirement 8: Author Dashboard

**User Story:** As an Author, I want to view statistics about my uploaded books, so that I can track reader engagement.

#### Acceptance Criteria

1. WHEN an Author navigates to the dashboard, THE App SHALL display total books uploaded, total reads, and total downloads for books owned by the authenticated Author
2. WHEN an Author taps on a book in the dashboard, THE App SHALL display detailed statistics for that book including read count and download count
3. WHEN an Author submits metadata edits for a book they have uploaded, THE App SHALL update the book's title, description, category, tags, cover image, and license type in the Supabase_Backend
4. WHEN an Author confirms deletion of a book, THE App SHALL remove the book record and its associated files from the Supabase_Backend and storage
5. WHEN an Author initiates a book deletion, THE App SHALL display a confirmation dialog requiring explicit confirmation before proceeding
6. IF a metadata edit or book deletion fails, THEN THE App SHALL display an error message indicating the failure reason and preserve the original data unchanged
7. IF an Author has no uploaded books, THEN THE App SHALL display an empty state message indicating no books have been uploaded

### Requirement 9: Admin Moderation

**User Story:** As an Admin, I want to review and moderate uploaded books, so that the platform maintains quality and legal compliance.

#### Acceptance Criteria

1. WHEN an Admin navigates to the moderation screen, THE App SHALL display all books with status "pending" sorted by submission date (oldest first), showing for each book: title, author name, cover image, upload date, and file format
2. WHEN an Admin approves a book, THE App SHALL update the book status to "published" and make the book appear in search results and category browsing within 5 seconds
3. WHEN an Admin rejects a book, THE App SHALL require a rejection reason between 10 and 500 characters, update the book status to "rejected", and send a notification to the Author containing the rejection reason
4. IF an Admin attempts to approve or reject a book that is no longer in "pending" status, THEN THE App SHALL display an error message indicating the book has already been moderated and refresh the moderation queue
5. WHEN an Admin bans a User, THE Auth_Service SHALL require a ban reason, invalidate the User's active session, prevent future logins, and change the status of all books published by that User to "unlisted" so they are no longer discoverable
6. WHEN a report is submitted against a book, THE App SHALL validate that the report contains a reason of at least 10 characters, associate the report with the book, set the report status to "pending", and add it to the Admin's review queue

### Requirement 10: Admin Dashboard and Content Management

**User Story:** As an Admin, I want to view platform analytics and manage content categories, so that I can monitor platform health and organize the book catalog.

#### Acceptance Criteria

1. WHEN an Admin navigates to the admin dashboard, THE App SHALL display total registered users, total published books, total authors, and the count of readers who have read at least one book within the last 30 days (active readers)
2. WHEN an Admin views analytics, THE App SHALL display the top 10 most read books ranked by total reads, the top 10 most active authors ranked by total reads across their books, and platform growth metrics showing new users, new books, and new authors added per month for the last 12 months
3. WHEN an Admin creates a category, THE App SHALL require a unique category name between 2 and 50 characters and persist the new category to the Supabase_Backend
4. WHEN an Admin edits a category, THE App SHALL allow updating the category name and persist the change to the Supabase_Backend
5. IF an Admin attempts to delete a category that has books assigned to it, THEN THE App SHALL display a warning indicating the number of assigned books and require the Admin to reassign or confirm removal before proceeding
6. WHEN an Admin manages featured books, THE App SHALL allow selecting between 1 and 20 published books to display in the featured section on the home screen
7. IF the Supabase_Backend is unavailable when loading the admin dashboard, THEN THE App SHALL display an error message indicating the data could not be loaded and offer a retry option

### Requirement 11: Dark Mode and Theming

**User Story:** As a User, I want to switch between light and dark themes, so that I can read comfortably in different lighting conditions.

#### Acceptance Criteria

1. THE App SHALL provide three theme options: light mode, dark mode, and system default, where system default follows the operating system's current theme setting
2. WHEN a User toggles the theme setting, THE App SHALL apply the selected theme to all screens including backgrounds, text, icons, and navigation elements within 500 milliseconds without requiring an app restart
3. THE App SHALL persist the User's selected theme preference in local storage and restore it on subsequent app launches
4. WHEN the App launches for the first time and no theme preference has been saved, THE App SHALL default to the system theme preference
5. IF the system theme preference cannot be determined, THEN THE App SHALL default to light mode

### Requirement 12: Offline Support

**User Story:** As a User, I want to download books for offline reading, so that I can read without an internet connection.

#### Acceptance Criteria

1. WHEN a User taps the download button on a book, THE App SHALL download the book file to local storage and indicate the book as "downloaded" in the UI
2. WHILE a download is in progress, THE App SHALL display download progress as a percentage updated at least every 2 seconds
3. WHILE the device is offline, THE App SHALL display a list of downloaded books and allow the User to open and read them using the Reader with full navigation and progress tracking capabilities
4. WHEN the device regains connectivity, THE Progress_Tracker SHALL sync any locally cached reading progress to the Supabase_Backend within 30 seconds of detecting connectivity
5. WHEN a User deletes a downloaded book, THE App SHALL display a confirmation prompt and upon confirmation remove the local file and free storage space
6. IF a download fails due to network interruption or timeout exceeding 60 seconds of inactivity, THEN THE App SHALL display an error message indicating the failure reason and offer a retry option while preserving any partially downloaded data
7. IF the device has insufficient storage space to complete a download, THEN THE App SHALL inform the User of the required space and cancel the download without corrupting existing downloaded books

### Requirement 13: Content Reporting

**User Story:** As a User, I want to report inappropriate or copyright-violating content, so that the platform remains safe and legal.

#### Acceptance Criteria

1. WHEN a User taps the report button on a book, THE App SHALL display a report form with reason categories (copyright violation, inappropriate content, spam, other) and an optional description field limited to 500 characters
2. IF a User selects "other" as the report reason, THEN THE App SHALL require the User to enter a description of at least 10 characters before allowing submission
3. WHEN a User submits a report, THE App SHALL store the report with the reporter ID, book ID, selected reason category, optional description, and timestamp with an initial status of "pending"
4. WHEN a report is successfully stored, THE App SHALL display a confirmation message to the User indicating the report has been received
5. IF a User has already reported the same book, THEN THE App SHALL prevent submission and display a message indicating a report already exists for this book
6. IF report submission fails due to a network or server error, THEN THE App SHALL display an error message and retain the entered report data so the User can retry without re-entering information
