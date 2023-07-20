import cv2
import numpy as np
from keras.models import Model
from keras.layers import Input, Conv2D, MaxPooling2D, Flatten, Dense, Lambda, Dropout, GlobalAveragePooling2D
from keras import backend as K


def create_model():
    inputs = Input((64, 64, 1))
    x = Conv2D(96, (11, 11), padding="same", activation="relu")(inputs)
    x = MaxPooling2D(pool_size=(2, 2))(x)
    x = Dropout(0.3)(x)

    x = Conv2D(256, (5, 5), padding="same", activation="relu")(x)
    x = MaxPooling2D(pool_size=(2, 2))(x)
    x = Dropout(0.3)(x)

    x = Conv2D(384, (3, 3), padding="same", activation="relu")(x)
    x = MaxPooling2D(pool_size=(2, 2))(x)
    x = Dropout(0.3)(x)

    pooledOutput = GlobalAveragePooling2D()(x)
    pooledOutput = Dense(1024)(pooledOutput)
    outputs = Dense(128)(pooledOutput)

    model = Model(inputs, outputs)
    return model


# Assuming you have a trained model and loaded the weights
# Create an instance of the model
model = create_model()

# Load the saved weights into the model
model.load_weights("model_weights.h5")

# Load the two images you want to compare
image1_path = ""
image2_path = ""


def takepath(im1, im2):
    image1_path = im1
    image2_path = im2

    image1 = cv2.imread(image1_path)
    image2 = cv2.imread(image2_path)

    # Preprocess the images (resize, convert to grayscale, normalize, etc.)
    preprocessed_image1 = cv2.cvtColor(image1, cv2.COLOR_BGR2GRAY)
    preprocessed_image1 = cv2.resize(preprocessed_image1, (64, 64))
    preprocessed_image1 = preprocessed_image1 / 255.0  # Normalize pixel values

    preprocessed_image2 = cv2.cvtColor(image2, cv2.COLOR_BGR2GRAY)
    preprocessed_image2 = cv2.resize(preprocessed_image2, (64, 64))
    preprocessed_image2 = preprocessed_image2 / 255.0  # Normalize pixel values

    # Expand the dimensions to match the input shape of the model
    input_image1 = np.expand_dims(preprocessed_image1, axis=0)
    input_image1 = np.expand_dims(input_image1, axis=-1)

    input_image2 = np.expand_dims(preprocessed_image2, axis=0)
    input_image2 = np.expand_dims(input_image2, axis=-1)

    # Make predictions using the model
    prediction1 = model.predict(input_image1)
    prediction2 = model.predict(input_image2)

    # Process the predictions as needed (e.g., thresholding, post-processing, etc.)
    threshold = 0.001  # Adjust the threshold value as per your requirements

   # if np.any((prediction1 > threshold) & (prediction2 > threshold)):
   #     return 1
    # else:
    #   return 0
    if np.all(abs(prediction1 - prediction2) < threshold):
        return 1
    else:
        return 0
