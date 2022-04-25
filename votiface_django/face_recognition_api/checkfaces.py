from fileinput import filename
import cv2
import face_recognition

def compare(faceDistance):
    if faceDistance > 0.5:  #reduce this value if you want to increase accuracy
        return False
    else:
        return True

def findEncoding(image): #returns 128-d encoding of the image
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    encode = face_recognition.face_encodings(image)[0]
    return encode

def comparison(firstphoto,secondphoto): #compares the two images and returns the bool result
    faceDistance = face_recognition.face_distance([firstphoto],secondphoto)
    results = compare(faceDistance)
    return results
