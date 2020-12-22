# -- The server is not running anymore --

# Hotdog/Not Hotdog Classifier

Classifying images into hotdog/not hotdog categories using CNN and Keras. Build from scratch, we did not use any pre-built models.

## Installation and usage guidelines (plug and play)

1. Download the used dataset (keras/dataset) and unzip it
2. Clone our repository and open the swift directory in XCode - the server is running on an aws instance already
3. Start the app, press the 'choose a picture'-button and choose a picture either from your own photo library or take a photo directly on your camera (iPhone only)
4. If the app is connected to the server, you will receive an answer whether the image you chose is a hotdog or not :)

## Installation and usage guidelines self hosting

1. Download the used dataset (keras/dataset) and unzip it
2. Clone our repository 
3. Download our used model (keras/<model_name>.h5) and put it inside the same directory as the flask script OR
4. If you want to train a new model using our training-notebook you have to specify the location of the training and testing directories of our dataset inside the notebook. Make sure to have Tensorflow and Keras installed.
After the training you have to save your model using the classifier.save(<your_modelName>.h5)-method. Don't forget to put your saved model inside the same directory as the flask script
5. Adjust the model name in the flask script inside the load-method if it's not the one we have trained
6. Start the backend by running the flask script (flaskBackend/run_keras_server.py), make sure to have the flask and pillow-dependencies installed
7. Open the swift directory in XCode and adjust the URL in the 'postImage'-function
8. Start the app, press the 'choose a picture'-button and choose a picture either from your own photo library or take a photo directly on your camera (iPhone only)
9. If the app is able to connect to the server, you will receive an answer whether the image you chose is a hotdog or not :)
