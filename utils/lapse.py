# This script was used to create the time-lapse video.
# Credit mostly goes to ChatGPT

import os
import cv2
import time
import imageio

# Settings
output_file = f"C:/Users/adamk/Videos/timelapse_{int(time.time())}.mp4"
capture_interval = 15 # 15 seconds
capture_duration = 60 * 60 * 36 # 36 hours
tmp_folder = f"C:/Users/adamk/Videos/tmp_frames_{int(time.time())}/"
fps = 60
cleanup = False

# Create a temporary folder to store frames
if not os.path.exists(tmp_folder):
    os.makedirs(tmp_folder)

# Capture frames using the webcam
cap = cv2.VideoCapture(1)  # Change to 0 if you have only one webcam
if not cap.isOpened():
    print("Error: Could not open webcam.")
    exit()

frame_count = 0
start_time = time.time()

while True:
    ret, frame = cap.read()
    if not ret:
        print("Error: Could not read frame.")
        break

    # Display the frame (for debugging)
    cv2.imshow('Frame', frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

    # Save the frame to the temporary folder
    frame_path = os.path.join(tmp_folder, f"frame_{frame_count:04d}.png")
    if cv2.imwrite(frame_path, frame):
        print(f"Frame {frame_count} saved successfully.")
    else:
        print(f"Failed to save frame {frame_count}.")
    frame_count += 1

    # Wait for the capture interval
    time.sleep(capture_interval)

    # Stop capturing after the specified duration
    if time.time() - start_time >= capture_duration:
        break

cap.release()
cv2.destroyAllWindows()

# Compile frames into a video
frames = []
for i in range(frame_count):
    frame_path = os.path.join(tmp_folder, f"frame_{i:04d}.png")
    frames.append(imageio.imread(frame_path))

imageio.mimwrite(output_file, frames, fps=fps)

# Remove temporary frames and folder
if cleanup:
    for i in range(frame_count):
        frame_path = os.path.join(tmp_folder, f"frame_{i:04d}.png")
        os.remove(frame_path)

    os.rmdir(tmp_folder)

print(f"Time-lapse video saved as {output_file}")
