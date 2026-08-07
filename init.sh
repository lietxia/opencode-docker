# /workspace 全部项目 git clone --depth=1 命令
# 生成时间: 2026-08-03
# 用途: 在新机器上以浅克隆方式恢复所有项目
# 说明: --depth=1 只拉取指定分支的最新提交; --branch 指定与本地一致的分支

cd ./code/
# ============ 普通项目 (github.com/lietxia) ============
git clone --depth=1 --branch master https://github.com/lietxia/LinKloud.git LinKloud
git clone --depth=1 --branch dev https://github.com/lietxia/Mahjong-YOLO.git Mahjong-YOLO
git clone --depth=1 --branch main https://github.com/lietxia/android-vm-for-mac.git android-vm-for-mac
git clone --depth=1 --branch main https://github.com/lietxia/appcn.git appcn
git clone --depth=1 --branch main https://github.com/lietxia/ech-doh.git ech-doh
git clone --depth=1 --branch main https://github.com/lietxia/hanzi.git hanzi
git clone --depth=1 --branch master https://github.com/lietxia/lietxia.github.io.git lietxia.github.io
git clone --depth=1 --branch master https://github.com/lietxia/mahjong-algorithm.git mahjong-algorithm
git clone --depth=1 --branch master https://github.com/lietxia/mahjong.pub.git mahjong.pub
git clone --depth=1 --branch master https://github.com/lietxia/mahjong.git mahjong
git clone --depth=1 --branch main https://github.com/lietxia/mahjong_index.git mahjong_index
git clone --depth=1 --branch main https://github.com/lietxia/mahjongpub_frontend.git mahjongpub_frontend
git clone --depth=1 --branch main https://github.com/lietxia/mdwiki.git mdwiki
git clone --depth=1 --branch main https://github.com/lietxia/mj.000.mk.git mj.000.mk
git clone --depth=1 --branch main https://github.com/lietxia/mj_api.git mj_api
git clone --depth=1 --branch master https://github.com/lietxia/mj_worker.git mj_worker
git clone --depth=1 --branch master https://github.com/lietxia/mjdb.git mjdb
git clone --depth=1 --branch master https://github.com/lietxia/mjwiki.git mjwiki
git clone --depth=1 --branch main https://github.com/lietxia/mortal_teather.git mortal_teather
git clone --depth=1 --branch main https://github.com/lietxia/mysql_init.git mysql_init
git clone --depth=1 --branch master https://github.com/lietxia/novel.git novel
git clone --depth=1 --branch master https://github.com/lietxia/offline-games.git offline-games
git clone --depth=1 --branch main https://github.com/lietxia/phonedev.git phonedev
git clone --depth=1 --branch master https://github.com/lietxia/qhlog.git qhlog
git clone --depth=1 --branch master https://github.com/lietxia/qqbot_nodejs.git qqbot_nodejs
git clone --depth=1 --branch master https://github.com/lietxia/rate_mahjong_pub_src.git rate_mahjong_pub_src
git clone --depth=1 --branch master https://github.com/lietxia/rc-api-worker.git rc-api-worker
git clone --depth=1 --branch master https://github.com/lietxia/riichi_advanced-go.git riichi_advanced-go
git clone --depth=1 --branch main https://github.com/lietxia/tianming-novel-ai-writer.git tianming-novel-ai-writer
git clone --depth=1 --branch master https://github.com/lietxia/tweb.git tweb
git clone --depth=1 --branch main https://github.com/lietxia/vTerm.git vTerm
git clone --depth=1 --branch main https://github.com/lietxia/xiuxian.git xiuxian
git clone --depth=1 --branch master https://github.com/lietxia/zdx.git zdx

# ============ 特殊仓库 ============
# gsz: 远程仓库名为 penlab-backup, clone 到本地 gsz 目录
git clone --depth=1 --branch master https://github.com/lietxia/penlab-backup.git gsz

