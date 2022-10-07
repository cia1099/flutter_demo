from pathlib import Path
import os, sys, time
import cv2
import numpy as np


def zoomInOutBlur(img, size):
    cblur = np.zeros(img.shape, img.dtype)
    for y in range(2):
        for x in range(2):
            ker = np.eye(size, dtype=np.float32)
            if x > 0:
                ker = np.fliplr(ker)
            if y > 0:
                ker = np.flipud(ker)
            ker /= np.sum(ker)
            sub_img = img[y * img.shape[0] // 2:(y + 1) * img.shape[0] // 2,
                      x * img.shape[1] // 2:(x + 1) * img.shape[1] // 2, :
                      ]
            sub_blur = cv2.filter2D(src=sub_img, ddepth=-1, kernel=ker)
            cblur[y * img.shape[0] // 2:(y + 1) * img.shape[0] // 2,
            x * img.shape[1] // 2:(x + 1) * img.shape[1] // 2, :] = sub_blur

    return cblur

if __name__ == '__main__':
    imgPathes = [
        'assets/images/asia.jpg',
        'assets/images/africa.jpg',
        'assets/images/europe.jpg',
        'assets/images/south_america.jpg',
        'assets/images/australia.jpg',
        'assets/images/antarctica.jpg',
    ]
    cv2.namedWindow('motion', cv2.WINDOW_NORMAL)
    size = 25
    p = 3
    mm = np.zeros((p,p,3), np.uint8)
    mm[:,:,1] = 255*np.eye(p, dtype=np.uint8)
    mm[:,p//2,(0,2)] = 255*np.ones((p,2), dtype=np.uint8)
    # cv2.imshow('motion', mm)
    # cv2.waitKey(0)
    cv2.imwrite('board.png', mm)
    for path in imgPathes:
        img = cv2.imread(path)
        print('{0:} has size: ({1:}, {2:}), type={3:}'.format(Path(path).stem, img.shape[0], img.shape[1], img.dtype))
        kernel = np.zeros((size,size), np.float32)
        horizon_kernel = kernel[size//2+1,:]+1/kernel.shape[1]
        vertical_kernel = kernel[:,size//2+1]+1/kernel.shape[0]
        cross_kernel = np.eye(size,dtype=np.float32) + np.fliplr(np.eye(size,dtype=np.float32))
        cross_kernel[size//2+1,size//2+1] -= 1
        cross_kernel /= np.sum(cross_kernel)

        hblur = cv2.filter2D(src=img, ddepth=-1, kernel=horizon_kernel)
        vblur = cv2.filter2D(src=img, ddepth=-1, kernel=vertical_kernel)
        cblur = zoomInOutBlur(img=img, size=size)
        cblur[img.shape[0]//6:img.shape[0]//6*5,
        img.shape[1]//6:img.shape[1]//6*5,:
        ] = zoomInOutBlur(img=img[img.shape[0]//6:img.shape[0]//6*5,img.shape[1]//6:img.shape[1]//6*5,:],size=13)

        cv2.imwrite(path[:-4]+'_blur.jpg', cblur)

        display = np.concatenate([vblur, cblur], axis=1)
        cv2.imshow('motion',display)
        cv2.waitKey(0)

