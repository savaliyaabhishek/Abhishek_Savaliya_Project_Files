import tensorflow as tf
import numpy as np



from keras.layers import Input, Conv2D, MaxPooling2D, Flatten, Dense, Lambda,Dropout,GlobalAveragePooling2D
from keras.models import Model,Sequential
from keras import backend as k
from keras.optimizers import Adam
from keras.losses import binary_crossentropy

from sklearn.datasets import fetch_olivetti_faces

# Fetch the Olivetti dataset
olivetti_faces = fetch_olivetti_faces()

# Access the data and target variables
images_dataset = olivetti_faces.data  # Input features (images)
labels_dataset= olivetti_faces.target  # Target labels (corresponding identities)

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


feature_extractor = create_model()
imgA = Input(shape=(64, 64, 1))
imgB = Input(shape=(64, 64, 1))
featA = feature_extractor(imgA)
featB = feature_extractor(imgB)


def euclidean_distance(vectors):
    (featA, featB) = vectors
    sum_squared = k.sum(k.square(featA - featB), axis=1, keepdims=True)
    return k.sqrt(k.maximum(sum_squared, k.epsilon()))

distance = Lambda(euclidean_distance)([featA, featB])
outputs = Dense(1, activation="sigmoid")(distance)
model = Model(inputs=[imgA, imgB], outputs=outputs)

model.compile(loss="binary_crossentropy", optimizer="adam", metrics=["accuracy"])
images_dataset = images_dataset.reshape(-1, 64, 64, 1)


def generate_train_image_pairs(images_dataset, labels_dataset):
    unique_labels = np.unique(labels_dataset)
    label_wise_indices = dict()
    for label in unique_labels:
        label_wise_indices.setdefault(label,
                                      [index for index, curr_label in enumerate(labels_dataset) if
                                       label == curr_label])
    
    pair_images = []
    pair_labels = []
    for index, image in enumerate(images_dataset):
        pos_indices = label_wise_indices.get(labels_dataset[index])
        pos_image = images_dataset[np.random.choice(pos_indices)]
        pair_images.append((image, pos_image))
        pair_labels.append(1)

        neg_indices = np.where(labels_dataset != labels_dataset[index])[0]
        neg_image = images_dataset[np.random.choice(neg_indices)]
        pair_images.append((image, neg_image))
        pair_labels.append(0)
    return np.array(pair_images), np.array(pair_labels)



images_pair, labels_pair = generate_train_image_pairs(images_dataset, labels_dataset)
history = model.fit([images_pair[:, 0], images_pair[:, 1]], labels_pair,validation_split=0.1,batch_size=64,epochs=100)



def generate_test_image_pairs(images_dataset, labels_dataset, image):
    unique_labels = np.unique(labels_dataset)
    label_wise_indices = dict()
    for label in unique_labels:
          label_wise_indices.setdefault(label,
                                        [index for index, curr_label in enumerate(labels_dataset) if
                                         label == curr_label])
  
    pair_images = []
    pair_labels = []
    for label, indices_for_label in label_wise_indices.items():
        test_image = images_dataset[np.random.choice(indices_for_label)]
        pair_images.append((image, test_image))
        pair_labels.append(1 if label == labels_dataset[np.argwhere(images_dataset==image)[0][0]] else 0)
    return np.array(pair_images), np.array(pair_labels)


image = images_dataset[92] # a random image as test image
test_image_pairs, test_label_pairs = generate_test_image_pairs(images_dataset, labels_dataset, image) # produce an array of test image pairs and test label pairs

# for each pair in the test image pair, predict the similarity between the images
for index, pair in enumerate(test_image_pairs):
    pair_image1 = np.expand_dims(pair[0], axis=-1)
    pair_image1 = np.expand_dims(pair_image1, axis=0)
    pair_image2 = np.expand_dims(pair[1], axis=-1)
    pair_image2 = np.expand_dims(pair_image2, axis=0)
    predictions = model.predict([pair_image1, pair_image2])[0][0]


# Save the weights of the model
model.save_weights("model_weights.h5")

