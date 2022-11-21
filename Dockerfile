# Only works ubuntu or debian bases
ARG base_image
FROM $base_image

USER root

# Install all the required packages
RUN apt-get update \
 && apt-get install -y \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    htop \
    curl \
    gdb \
    git \
    tree \
    wget \
    xclip \
    fuse \
    libfuse2 \
&& apt-get clean

RUN curl -sL https://github.com/sharkdp/fd/releases/download/v8.3.2/fd_8.3.2_amd64.deb -o fd.deb && dpkg -i fd.deb
RUN curl -sL https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb -o rg.deb && dpkg -i rg.deb
RUN curl -sL https://github.com/neovim/neovim/releases/download/v0.8.1/nvim.appimage -o /usr/local/bin/nvim
RUN chmod +x /usr/local/bin/nvim

# CPP LSP
ARG cpp_enable="false"
RUN if [ "$cpp_enable" = "true" ] ; then wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 13 all ; fi
RUN if [ "$cpp_enable" = "true" ] ; then update-alternatives --install /usr/bin/clang clang /usr/bin/clang-13 100 ; fi
RUN if [ "$cpp_enable" = "true" ] ; then update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-13 100 ; fi
RUN if [ "$cpp_enable" = "true" ] ; then update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-13 100 ; fi
RUN if [ "$cpp_enable" = "true" ] ; then update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-13 100 ; fi
RUN if [ "$cpp_enable" = "true" ] ; then update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-13 100 ; fi

# Rust LSP

ARG user_name=devo_docker
ARG user_id=1001

RUN useradd -m $user_name -u $user_id && \
    usermod --uid $user_id $user_name && \
    groupmod --gid $user_id $user_name

# Setup Entrypoint
USER $user_name
CMD ["bash"]
