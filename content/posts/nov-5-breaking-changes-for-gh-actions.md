---
title: "2024年11月5日にやってきた (今後やってくる) GitHub Actions への破壊的変更"
date: 2024-11-07
tags: ["github"]
# author: ""
showToc: true
TocOpen: false
draft: false
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: ""
    alt: ""
    caption: ""
    relative: false
    hidden: true
---

2024年11月5日に GitHub から GitHub Actions への破壊的変更に関するアナウンスが公開された．特に Ubuntu ( `ubuntu-latest` ) に関する変更がやばそう．

公式アナウンス: [Notice of breaking changes for GitHub Actions](https://github.blog/changelog/2024-11-05-notice-of-breaking-changes-for-github-actions/)

## `ubuntu-latest` が指すバージョンが Ubuntu 22 から Ubuntu 24 へ

- 2024年12月5日以降，`ubuntu-latest` が指すバージョンが **Ubuntu 22 から Ubuntu 24 へと変更される**．
- また Ubuntu 24 のディスク容量 SLA を維持するため，いくつかのパッケージが削除・変更された．
  - 影響を受けるパッケージのリストについては [actions/runner-images#10636](https://github.com/actions/runner-images/issues/10636) で言及されている．
  - Node.js や Clang など古いバージョンが削除されるものもあれば Vercel CLI や Netilify CLI などの **ツール系** は軒並み削除されている．(理由としては **Removed from the Ubuntu 24.04 image due to maintenance reasons.** とある．まあ妥当だよね．)
- 削除されるパッケージに依存しているワークフローに至っては12月5日以降正常に動作しなくなる可能性が高い．早急に対応したほうがいい．

## Artifacts v3 の brownout

- Artifacts Actions `actions/upload-artifact`, `actions/download-artifact` の v3 は**2024年12月5日に使用できなくなる**．
- 近々予定されている上記変更の注意喚起を行うため，独自の brownout を実施する．
- 以下の期間中，これらの Actions を使用しているジョブは強制的に失敗するとのこと．
  - November 14, 12pm – 1pm EST
  – November 21, 9am – 5pm EST

## Fork Repository からの PR における検証フローの変更

- 現在 Fork Repository からの PR は自動的に実行できないようになっている．
- 2024年11月5日から GitHub Actions では Fork Repository からのプルリクエストは **プルリクエスト作成者** & **イベントアクター ( Repository の Owner など)** 両者の承認が必要になる．

## Webhook のレート制限追加

- 2024年11月5日から GitHub Actions では Repository ごとの Webhook レート制限を導入する．
  - 各リポジトリのトリガーイベントは 10 秒ごとに 1500 件に制限される
