#docker安装与注册

    1.安装python文件
        sudo yum install -y python36
    2.安装docker
        sudo yum install -y yum-utils device-mapper-persistent-data lvm2
        sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
        sudo yum install docker-ce
    3.启动docker
        systemctl enable docker
        systemctl start docker
    4.下载docker python3.6的镜像
        docker search python #查看python相关的镜像文件
        docker pull markadams/chromium-xvfb-py3    #这个是selenium的一个镜像,包含python36
    5.下载xk_monitor配置文件，然后build创建新的镜像文件xkmonitor
        docker build -t xkmonitor -f Dockerfile .
        docker run  -d -i -t xkmonitor /bin/bash    #如果能够进入表示已经启动
    6.注册docker账号，然后创建命名空间xkool-monitor
        docker images获取xkmonitor的image id
        然后给xkmonitor镜像打完tag
        docker tag image_id soloxmas/xkool-monitor
        docker login #输入注册的用户名和密码 
        docker push soloxmas/xkool-monitor #把打好tag的image推送到docker库中以便拉取,这一步比较慢
    
    
#以下是k8s的部分

    1.下载kubectl
        curl -Lo kubectl    http://kubernetes.oss-cn-hangzhou.aliyuncs.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl
        chmod +x kubectl
        cp kubectl /usr/local/bin

    2.下载minikube后启动
        curl -Lo minikube http://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v1.4.0/minikube-linux-amd64
        chmod +x minikube
        cp minikube /usr/local/bin
        minikube start --vm-driver=none
        minikube status #查看状态
    3.创建k8s命名空间
        kubectl create namespace xkool-monitor
    4.通过配置文件来运行容器
        kubectl apply -f monitor-deploy-port.yml

    5.把pod中的端口映射出来
        echo 1 > /proc/sys/net/ipv4/ip_forward  #开启linux转发功能

#其他k8s常用命令

##k8s中正确删除一个pod  

    先删除pod，再删除deployment
        kubectl get pod -n xkool-monitor        #查看有哪些pod在运行
            [root@localhost xk_monitor]# kubectl get pod -n xkool-monitor
            NAME                             READY   STATUS    RESTARTS   AGE
            monitor-5746bfdb9b-hnrsq         1/1     Running   0          4m8s
            xkool-monitor-6cd4d56f55-9hvjx   1/1     Running   2          6h53m
        kubectl get deployment -n xkool-monitor #查看有哪些pod在运行
            [root@localhost xk_monitor]# kubectl get deployment -n xkool-monitor
            NAME            READY   UP-TO-DATE   AVAILABLE   AGE
            monitor         1/1     1            1           9m58s
            xkool-monitor   1/1     1            1           6h59m
    kubectl delete pod xkool-monitor-6cd4d56f55-9hvjx -n xkool-monitor  #删除pod
    kubectl delete deployment xkool-monitor -n xkool-monitor            #删除deployment

    
#参考：

    K8S deployment.yml配置详解:
    https://blog.csdn.net/random_w/article/details/80612881
    minikube安装详解:
    https://mp.weixin.qq.com/s/QIsQoWmuZbmhXViLXxBN9A
