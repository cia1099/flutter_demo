# my_heart

My honey project.

## Getting Started

demo site: https://my-honey.web.app

## Deploy

* install nvm and node
```shell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
source ~/.bashrc
# verify installation
command -v nvm && nvm -v
nvm install node 14
nvm list
nvm use node [version] # change version
```
* setup Firebase CLI
```shell
npm install -g firebase-tools
firebase login
firebase projects:list
# if you'd like to access firebase
firebase login:ci
```
* [Test and preview](https://firebase.google.com/docs/hosting/manage-hosting-resources)
在發布預覽前，先在**firebase Hosting**網頁新增其他網站，自己另命名一個Site-Id，之後這個Site-Id要在先前執行`firebase init hosting`生成的`firebase.json`，裡面標記deploy的域名地方：
```json
{
  "hosting": {
    "site": "my-honey",
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```
之後可以清除先前的建置，重新建一個release版

```shell
flutter clean
flutter build web
# deploy to preview channel within 1 day
firebase hosting:channel:deploy preview-version --expires 1d
# if you satisfied this preview, you can clone to live channel
firebase hosting:clone my-honey:preview-version my-honey:live
```
### Dismiss url __#__
```yaml
dependencies:
  flutter:
    sdk: flutter
    #...
  url_strategy: ^0.2.0
```
edit `main.dart`:
```dart
void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}
```

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

