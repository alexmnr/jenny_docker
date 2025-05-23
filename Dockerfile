# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv
FROM osrf/ros:jazzy-desktop-full

#### Basic Stuff ####
RUN apt-get update && apt-get upgrade -y
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales curl wget git net-tools fd-find ripgrep file apt-utils lsb-release locales xauth xclip ssh python3-pip

# install locales
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8

# create user
RUN useradd -m -p '' ros
RUN usermod -aG sudo ros
RUN usermod -aG tty ros
USER ros

# adding shell customization
RUN sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y zsh vim 
RUN mkdir $HOME/.tmp
RUN curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o $HOME/.tmp/install.sh
RUN chmod +x $HOME/.tmp/install.sh
RUN sudo git clone https://github.com/ohmyzsh/ohmyzsh.git /usr/local/zsh/oh-my-zsh
RUN sudo git clone https://github.com/zsh-users/zsh-autosuggestions /usr/local/zsh/oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/local/zsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
RUN $HOME/.fzf/install --key-bindings --no-completion --no-update-rc
COPY config/.zshrc /home/ros/
RUN cd $HOME && sudo chown ros:ros .zshrc

# make sure your domain is accepted
RUN mkdir $HOME/.ssh
RUN touch $HOME/.ssh/known_hosts
RUN ssh-keyscan github.com >> $HOME/.ssh/known_hosts

#### get Repository ####
RUN cd $HOME && git clone https://github.com/alexmnr/jenny_ros2.git

#### Install ROS librarys ####
RUN rosdep update
RUN cd /home/ros/jenny_ros2/ros/ && export PIP_BREAK_SYSTEM_PACKAGES=1 && rosdep install --from-paths src -y --ignore-src

# build workspace
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    cd $HOME/jenny_ros2/ros && colcon build
