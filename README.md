# Flutter Todo App Readme

## Description

This Flutter application is a versatile Todo app that empowers users to efficiently create, manage, and organize tasks with ease. Here's a concise overview of its features:

- **Task Management:** Users can create tasks by providing a title, description, and due date. These tasks are initially listed in the main todo screen as open items.

- **Status Control:** Tasks can be marked as "closed," moving them to a dedicated closed tab. Users can also re-open closed tasks by simply clicking on them in the closed tab.

- **Editing and Deletion:** The app offers the flexibility to edit task details or delete tasks as needed.

- **Weather Information:** A dedicated screen provides users with access to real-time weather updates in their city, with Montreal as the default location.

- **User Profile:** Users can access their profile screen, where they can view their registration date, upload a profile picture, and sign out from the app.

- **Navigation Drawer:** The app features a handy side menu, granting quick access to all app sections (excluding login). It also displays the user's profile picture and, if signed in with Google, their email address at the top.

## How to Use the App

1. **Login**: Upon launching the app, users are greeted with a login page, offering two options: anonymous login or Google Sign-In.

2. **Main Todos Screen**: After logging in, users land on the main todos screen, where they can click the "Create Todo" button to navigate to the "Add New Todo" screen.

3. **Add New Todo**: In the "Add New Todo" screen, users can input a title, description, and choose a due date using a calendar widget. Once they hit the submit button, they return to the main todo screen, where their newly created task is displayed, along with edit and delete icons.

4. **Task Management**: On the main todo screen (open tab), users can move tasks from the open tab to the closed tab by clicking the radio button (empty circle) on the left side of the task.

5. **Editing Tasks**: To modify a task, simply click on the pencil icon, which opens a modal window for editing the title, description, and date.

6. **Deleting Tasks**: To delete a task, click on the trash can icon, triggering a confirmation window to ensure the user's intent.

7. **Navigation Drawer**: The side menu can be accessed from any screen by clicking on the hamburger menu in the top left corner. It displays the user's profile picture (if added through the profile screen), their email address (for Google sign-ins), or "Anonymous User" if no email is associated. Users can navigate to other app sections such as Todo List, Weather, My Profile, Add New Todo, and Sign Out.

8. **Weather Information**: Clicking on "Weather" takes users to the weather screen, where they can check weather conditions in their city. Users can update the location to reflect their current city.

9. **User Profile**: The "My Profile" screen provides information about the user's registration date, email (for Google sign-ins), and the ability to upload a profile picture or sign out from the app.

Enjoy using the Flutter Todo app for efficient task management and staying updated on the weather, all in one convenient application!
