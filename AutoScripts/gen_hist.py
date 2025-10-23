import cv2
import matplotlib.pyplot as plt
import numpy as np

# img = plt.imread("C:\\Users\\tuanng4x\\Workspace\\cfg-netspeed\\src\\sw\\noc_dev\\GUICore\\images\\icons\\show_lat_histogram.png")
img = cv2.imread("C:\\Users\\tuanng4x\\Workspace\\cfg-netspeed\\src\\sw\\noc_dev\\GUICore\\images\\icons\\show_lat_histogram.png", cv2.IMREAD_UNCHANGED)

if img.shape[2] == 4:
    bgr = img[..., :3]
    alpha = img[..., 3]
else:
    bgr = img
    alpha = None

hsv = cv2.cvtColor(bgr, cv2.COLOR_BGR2HSV)
h, s, v = cv2.split(hsv)

h_new = (h - 90) % 180
# s_new = np.clip(s.astype(np.float32) * 2, 0, 255).astype(np.uint8)
# v_new = np.clip(v.astype(np.float32) * 0.7, 0, 255).astype(np.uint8)
hsv_new = cv2.merge([h_new, s, v])
bgr_img = cv2.cvtColor(hsv_new, cv2.COLOR_HSV2BGR)

if alpha is not None:
    rgba_img = cv2.merge([bgr_img, alpha])
else:
    rgba_img = bgr_img

# rgb_color = (6, 84, 40)
# height, width = img.shape[:2]

# rgb_img = np.full((height, width, 3), rgb_color, dtype=np.uint8)
# if alpha.ndim == 2:
#     alpha = alpha[:, :, np.newaxis]
# alpha = alpha.astype(rgb_img.dtype)
# rgba_img = cv2.merge([rgb_img, alpha])

# if img.ndim == 3:
#     img_gray = np.dot(img[..., :3], [0.2989, 0.5870, 0.1140])
# else:
#     img_gray = img

# binary = (img_gray > 0.6).astype(np.uint8) * 255

# h, w = binary.shape
# color_img = np.zeros((h, w, 3), dtype=np.uint8)
# color_img[binary == 255] = [255, 255, 255]
# color_img[binary == 0] = [255, 0, 0]

plt.subplot(1, 2, 1)
plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGRA2RGBA))

plt.subplot(1, 2, 2)
plt.imshow(cv2.cvtColor(rgba_img, cv2.COLOR_BGRA2RGBA))

plt.imsave("show_op_histogram.png", cv2.cvtColor(rgba_img, cv2.COLOR_BGRA2RGBA))

plt.show()

plt.close()

# width_px = 20
# height_px = 20
# dpi = 96

# width_in = width_px / dpi
# height_in = height_px / dpi

# # Create figure with exact size (200x200 pixels)
# fig = plt.figure(figsize=(width_in, height_in), dpi=dpi, facecolor='none')
# ax = fig.add_subplot(111)

# # Simple data for 3 connected bars
# x_positions = [1, 2, 3]
# bar_heights = [0.6, 0.9, 0.8]  # Different heights for visual appeal
# bar_colors = ['red', 'blue', 'green']

# # Create the bars with no gaps (width=1.0 to connect them, =0.95 got some gap)
# bars = ax.bar(x_positions, bar_heights, color=bar_colors, width=0.95, 
#               edgecolor='black', linewidth=1)

# # Remove axes for clean icon look
# ax.set_xlim(0.5, 3.5)
# ax.set_ylim(0, 1)
# ax.set_xticks([])
# ax.set_yticks([])
# ax.spines['top'].set_visible(False)
# ax.spines['right'].set_visible(False)
# ax.spines['bottom'].set_visible(False)
# ax.spines['left'].set_visible(False)

# # Make the plot area transparent
# ax.patch.set_visible(False)

# # Add "Opcode" text spanning across all bars at 45 degrees
# # Position it in the center of all bars
# center_x = (x_positions[0] + x_positions[-1]) / 2
# center_y = 0.4  # Middle height

# # ax.text(center_x, center_y, 'Opcode', fontsize=26, fontweight='bold', 
# #         color='yellow', ha='center', va='center',
# #         rotation=45,  # 45-degree rotation
# #         # No background box for transparent effect
# #         bbox=None)

# # Save as PNG with transparent background
# # plt.tight_layout()
# plt.subplots_adjust(left=0.05, right=0.95, top=0.95, bottom=0.05)
# plt.savefig('histogram_opcode_connected_20x20.png', 
#             dpi=dpi, 
#             bbox_inches=None,
#             facecolor='none',
#             edgecolor='none',
#             transparent=True,
#             pad_inches=0)

# print("Connected histogram icon with 45-degree Opcode text saved as 'histogram_opcode_connected_200x200.png'")
# plt.close()

