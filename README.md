# BashPlayGround
Advancing my Bash scripting skills

mkdir Github && cd Github && mkdir DocLock17 && cd DocLock17 && sudo apt-get install git -y && git clone http://www.github.com/DocLock17/BashPlayGround && cd BashPlayGround && sudo bash installSuite.sh



sudo apt install python3-pip -y && pip3 install tensorflow-gpu==2.4.0

export PATH=/usr/local/cuda-11.4/bin${PATH:+:${PATH}}


https://developer.nvidia.com/rdp/cudnn-archive

https://developer.nvidia.com/cuda-downloads

/etc/resolv.conf.
nameserver 8.8.4.4
nameserver 8.8.8.8

resolvectl status

addresses: [8.8.8.8, 8.8.4.4]
            addresses: [7.7.7.7, 10.0.0.1]
            search: [mydomain, otherdomain]


# Let NetworkManager manage all devices on this system
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    wlx000f00730875:
      addresses:
        - 10.0.0.87/24
      gateway4: 10.0.0.1
      nameservers:
          addresses: [8.8.8.8, 8.8.4.4, 7.7.7.7, 10.0.0.1]

              search: [mydomain, otherdomain]
              dfd
              
# true location of network gui settings              
/etc/NetworkManager/system-connections


W: Failed to fetch http://archive.lambdalabs.com/ubuntu/dists/focal/InRelease  Temporary failure resolving 'archive.lambdalabs.com'
W: Some index files failed to download. They have been ignored, or old ones used instead.
Err:1 http://archive.lambdalabs.com/ubuntu focal InRelease                                          
  Something wicked happened resolving 'archive.lambdalabs.com:http' (-5 - No address associated with hostname)

