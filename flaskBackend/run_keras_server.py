# import the necessary packages
#from keras.preprocessing.image import img_to_array
from keras.preprocessing import image
from keras.models import load_model
from PIL import Image
import numpy as np
import flask
import io

app = flask.Flask(__name__)
model = None

def load():
	global model
	model = load_model("Adadelta_87_85.h5")

def prepare_image(img):

	img = img.resize((64,64))
	img_tensor = image.img_to_array(img)
	img_tensor = np.expand_dims(img_tensor, axis=0)
	img_tensor /= 255.

	return img_tensor




@app.route("/", methods=["GET"])
def hello():
	return flask.jsonify("Hallo")

@app.route("/predict", methods=["POST"])
def predict():

	if flask.request.method == "POST":
		if flask.request.files.get("image"):
			# read the image in PIL format
			img = flask.request.files["image"].read()
			img = Image.open(io.BytesIO(img))

			# preprocess the image and prepare it for classification
			img = prepare_image(img)

			preds = model.predict_classes(img)
			results = preds[0][0]
			data = ""

			if results == 0:
				data = "hotdog"
			else:
				data = "No hotdog"
			
	return flask.jsonify(data)

if __name__ == "__main__":
	print(("* Loading Keras model and Flask starting server..."
		"please wait until server has fully started"))
	load()
	app.run(host = '0.0.0.0', debug = False, threaded = False)
