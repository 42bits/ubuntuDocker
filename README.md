
镜像0：
Dockerfile

镜像1：
docker pull registry.cn-hangzhou.aliyuncs.com/jshawcx/ubuntunginxphpgoredismysql

镜像2：
docker pull registry.cn-hangzhou.aliyuncs.com/jshawcx/ubunturedisphpgo

不挂载 数据库 注释掉 # data

如果是跑golang，基础镜像建议使用 alpine，编译使用golang：alpine


