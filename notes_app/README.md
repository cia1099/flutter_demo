# notes_app

A similar Google Keep application.
Only completed frontend, this app do not use any backend.

## Getting Started

- Visit this site: https://notes-app-0915.firebaseapp.com


## How to change App Icon

- https://www.youtube.com/watch?v=drAeE4qKjDQ
- [Icons8](https://icons8.com/)
- [favicon.io](https://favicon.io/)

先在Icons8下載想要的Icon，抓最大且是`.png`的圖檔，再用favicon得到一系列的Icon大小。

針對web的圖標，在`/web`資料夾下有`index.html`和`manifest.json`要修改，`index.html`是修改網頁的圖標，`manifest.json`則是修改PWA用的圖標。

1. 要修改網頁的Icon，先將從favicon下載的`favicon.ico`檔案放置在`/web`資料夾內，可以刪除`favicon.png`，然後修改`/web/index.html`:
```html
<!-- Favicon -->
   <!-- 刪除 <link rel="shortcut icon" type="image/png" href="favicon.png"/> -->
  <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
  <link rel="icon" href="favicon.ico" type="image/x-icon">
```

2. 修改PWA的Icon，只要將從favicon下載的圖標在相同尺寸下，更改成和Flutter預設的檔名相同，然後再覆蓋到`/web/icons`即可。

3. 注意在`MaterialApp`設定的Title不會和鏈接的標題一樣，還要在`index.html`和`manifest.json`改好對應的attributes。如果想有更完整的描述，可以再修改`description`attribute。

<font color=ff00ff>如果`/web`改爛了，直接刪除再到終端輸入`flutter create .`重生一個預設的就好。</font>
