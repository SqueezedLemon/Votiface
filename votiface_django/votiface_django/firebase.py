import pyrebase

firebaseConfig = {'apiKey': "AIzaSyD-2JSggpP8aY1Zf4jRQWLTjLDdO3OhMFw",
  'authDomain': "votiface.firebaseapp.com",
  'databaseURL': "https://votiface-default-rtdb.asia-southeast1.firebasedatabase.app",
  'projectId': "votiface",
  'storageBucket': "votiface.appspot.com",
  'messagingSenderId': "188034785273",
  'appId': "1:188034785273:web:61b1c063c3c61130a32728",
  'measurementId': "G-BVP5NXWQX6",
}

firebase = pyrebase.initialize_app(firebaseConfig)
auth = firebase.auth()
db = firebase.database()
storage = firebase.storage()