# 📚 Sign Language Learning Application

An innovative mobile application designed for **teachers** and **students** in **sign language** classes. This app provides **real-time speech-to-text** conversion, allowing students to follow lessons through subtitles while enabling teachers to save and share courses for future consultation.

## 🚀 Features

✅ **Real-Time Speech-to-Text:** Converts teacher's speech into live subtitles for students.  
✅ **Course Saving & Retrieval:** Teachers can save, update, and allow students to revisit previous lessons.  
✅ **User Role Management:** Supports **teachers** and **students** .  
✅ **Modern UI/UX:** Built with **Flutter** for a responsive and smooth user interface.  
✅ **Cross-Platform:** Available for **Android** and **iOS**.  
✅ **Secure & Scalable:** Powered by **Spring Boot** for a robust and scalable backend.  

## 🛠️ Technologies Used

- **Frontend:** Flutter (Dart)
- **Backend:** Spring Boot (Java)
- **Database:** MySQL
- **APIs:** RESTful API
- **Speech Recognition:** Google Speech-to-Text

## 📱 Installation Guide

### Prerequisites
- Flutter SDK installed ([Get Started](https://docs.flutter.dev/get-started/install))
- Java (JDK 17+) and Spring Boot environment setup
- MySQL or PostgreSQL database

### Backend (Spring Boot)

1. Clone the repository:

   ```bash
   git clone https://github.com/your-repo.git
   cd your-repo/backend
   ```

2. Configure **application.properties**:

   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/your_db
   spring.datasource.username=your_username
   spring.datasource.password=your_password
   ```

3. Run the backend:

   ```bash
   ./mvnw spring-boot:run
   ```

### Frontend (Flutter)

1. Navigate to the Flutter project:

   ```bash
   cd your-repo/frontend
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the Flutter app:

   ```bash
   flutter run
   ```

## 📊 API Endpoints (Example)

| Method | Endpoint                          | Description                |
|--------|-----------------------------------|----------------------------|
| GET    | `/cours/all`                      | Fetch all courses          |
| POST   | `/cours/add`                      | Create a new course        |
| POST   | `/cours/saved/{id}`               | saved course               |
| GET    | `/cours/get_cours_in_progress}`   | Get courses in progress    |
| GET    | `/cours/get_cours_completed}`     | Get courses compelted      |
| GET    | `/cours/getSubtitleLast20Words}`  | Get subtitles last 20 words|
--------------------------------------------------------------------------

## 📸 Screenshots

| Login Screen              |
|---------------------------|
| ![image](https://github.com/user-attachments/assets/792215a7-12d8-4147-b506-a283fdc13ee6)

| Courses screen            |
|---------------------------|
|![image](https://github.com/user-attachments/assets/ab6a80b8-f3fd-453a-a0ae-e5017f42efed)

| teacher room screen & subtitle       |
|--------------------------------------|
| ![image](https://github.com/user-attachments/assets/35aeb39f-df05-474d-9587-2874677744c4)


## 📌 Future Enhancements

- ✅ Integration of **video sign language** for better understanding.
- ✅ Improved subtitle accuracy through **AI/ML** models.
- ✅ Multi-language support.

## 🤝 Contributing

1. Fork the repository.
2. Create your feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -m 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Open a pull request.

## 📄 License

This project is licensed under the **MIT License**.

## 💌 Contact

For any inquiries or contributions:
- **Email:** nasreddine.elmadhkour@gmail.com
- **LinkedIn:** [Nasseredine El Madkhour](https://www.linkedin.com/in/nasreddineelmadhkour)
