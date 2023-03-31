# kitemiru

## 1. 概要

バーチャル試着アプリ

### ディレクトリ

- [backend](backend/): バックエンド
- [docs](docs/): 全体に関するドキュメンテーション
- [frontend](frontend/): フロントエンド

## 2. 環境構築の手順

### 2.1. 開発環境

docker のネットワーク作成 → docker 立ち上げ

```bash
# docker のネットワーク作成（最初に一回だけ実行）
> make mk_network

# 開発環境のdockerを立ち上げ（毎回実行．Cmd+Cで終了）
> make dev
```

ネットワークができているか確認するには下記を実行し，`kitemiru_next_network`があることを確認

```bash
# 確認方法
> docker network ls

NETWORK ID     NAME                    DRIVER    SCOPE
...
何かしらのID　   kitemiru_next_network   bridge    local
...
```

環境をリセットしたいときは下記を実行

```bash
# イメージ、コンテナ、ネットワークを削除
> make free
```

kitemiru_next_network だけ削除する場合

```bash
#kitemiru_next_network だけ削除
> make rm_network
```

## 備忘録

- [最初の環境構築](docs/project-initialization.md)
