## 概要
ぐるなびのレストラン検索APIを使用したレストラン検索＆リスティングアプリです。
飲み会幹事で大変な思いをしたことをきっかけに、幹事する人の助けになるものを作れないか、という想いをきっかけに作成しました。
初めてのiOSアプリ開発ということで簡単な機能しか実装されていませんが、これを足掛けに有益なアプリを開発していきたいと考えています。

大まかな機能としては「アカウント認証」「レストラン検索」「店舗情報のリスティング」が実装されています。

## :beers:開発環境
* Xcode 11.3
* Swift 5.1.3
* Cloud Firestore

## :iphone:Top画面
<img src="https://user-images.githubusercontent.com/54034385/75360936-da40c400-58f9-11ea-864e-c5d44a3c9a3f.png" width=30% height=30%>

## :beers:アプリ機能
**1. :lock:アカウント認証**

Cloud Firebaseを用いたメール認証

    Top画面の「ログインして始める」ボタン押下。
      ▶️ ①画面に遷移。emailとpasswordの欄に入力後登録ボタン押下。
        ▶️ ②画面のようにポップアップ発生。OKボタン押下。
          ▶️ 記入したアドレス宛に認証メールが届く。メールのリンクを押下してメール認証。
            ▶️ Top画面に強制遷移
            (メールのリンクを押下する前に「ログインして始める」ボタンを押下すると③の画面のようなポップアップが発生する。)

<table>
<tr>
<th>①</th>
<th>②</th>
<th>③</th>
</tr>
<tr>
<td><img src="https://user-images.githubusercontent.com/54034385/75360130-ba5cd080-58f8-11ea-9e64-271275fe10e2.png"></td>
<td><img src="https://user-images.githubusercontent.com/54034385/75363621-b54e5000-58fd-11ea-873c-3600bc2f9459.png"></td>
<td><img src="https://user-images.githubusercontent.com/54034385/75360692-87ffa300-58f9-11ea-9e12-8ebc864fa0ae.png"></td>
</tr>
</table>


:wastebasket:アカウントの削除機能もあります。

Top画面の「退会」ボタン押下後、登録したemailとpasswordを記入し「退会」ボタン押下でアカウントが削除されます。

<img src="https://user-images.githubusercontent.com/54034385/76066032-1518bb00-5fd0-11ea-960f-470caddbac30.png" width=30% height=30%>

**2. :mag:レストラン検索機能**

ぐるなびのレストラン検索APIを使用してフリーワード検索ができます。

    Top画面の「フリーアカウントで始める」ボタン押下、あるいはメール認証後「ログインして始める」ボタン押下。
      ▶️ ①画面に遷移。「店舗検索」ボタン押下。
        ▶️ ②画面に遷移。画面上部のテキストボックスに検索ワードを記入し、表示件数を指定(未記入の場合は10となる)し、検索ボタン押下。
          ▶️ ③画面のように、検索ワードにヒットした店舗の情報が表示される。
          (「リストに追加する」ボタンより上部のどこかをタッチするとSafariが起動しぐるなびの店舗情報ページに遷移する。)

<table>
<tr>
<th>①</th>
<th>②</th>
<th>③</th>
</tr>
<tr>
<td><img src="https://user-images.githubusercontent.com/54034385/75365080-08c19d80-5900-11ea-8dea-ad46d05ed09d.png"></td>
<td><img src="https://user-images.githubusercontent.com/54034385/75365087-0bbc8e00-5900-11ea-80f2-a40114ad0fcd.png"></td>
<td><img src="https://user-images.githubusercontent.com/54034385/75365090-0c552480-5900-11ea-8c62-be9662ab55bb.png"></td>
</tr>
</table>

**3. :green_book:店舗情報のリスティング**

気になった店舗をリスティングすることができる

    レストラン検索画面の「リストに追加する」ボタン押下。
      ▶️ ①画面のようにポップアップが出る。「はい」ボタン押下。
        ▶️ 2.レストラン検索機能の①画面より「マイ店舗リスト」ボタンを押下すると「リストに追加する」ボタンで「はい」を選択した店舗情報が②画面に表示される。
          ▶️ ③画面のように、「リストから削除する」ボタンを押下するとポップアップが表示され「はい」を押下するとリストから削除することができる。

<table>
<tr>
<th>①</th>
<th>②</th>
<th>③</th>
</tr>
<tr>
<td><img src="https://user-images.githubusercontent.com/54034385/76065026-2791f500-5fce-11ea-824f-dcc715e9013d.png"></td>
<td><img src="https://user-images.githubusercontent.com/54034385/76065043-2cef3f80-5fce-11ea-9aa2-a444fc594d0b.png"></td>
<td><img src="https://user-images.githubusercontent.com/54034385/76065044-2e206c80-5fce-11ea-99fe-f5ad298e85eb.png"></td>
</tr>
</table>
