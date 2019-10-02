ORIGINAL_USER=$(whoami)

echo "Hello $(whoami),"
sleep 1
echo "I'm going to configure your computer now."
sleep 1
echo "I'll need a couple of things from you throughout the process"
echo "So I'll get them from you now..."
sleep 2

echo "Github requires a few global settings to be configured"
echo "Enter the email address associated with your GitHub account: "
read -r email
echo "Enter your full name (Ex. John Doe): "
read -r username

# Configure Git
echo "Configuring Git"
git config --global --replace-all user.email "$email"
git config --global --replace-all user.name "$username"

if [ -f "~/.ssh/id_rsa" ]; then
    echo "SSH Key exists"
else
    ssh-keygen -t rsa -b 4096 -C "$email"
    eval "$(ssh-agent -s)"
fi

sudo dnf install fedora-workstation-repositories

# Corsair keyboard driver
if [ -x "$(command -v ckb-next)" ]; then
    echo "ckb-next installed"
else
    sudo dnf install ckb-next -y
fi;

# ZSH
if [ -x "$(command -v zsh)" ]; then
    echo "ZSH installed"
else
    sudo dnf install zsh -y
fi;

echo "Configuring Oh My ZSH"
{ # your 'try' block
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
} || { # your 'catch' block
    echo 'Oh My Zsh like to exit for some reasons so this prevents it'
}

# Configure ZSH  plugins
echo "Configuring ZSH plugins"
{
    git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    sed -i 's/plugins=(git)/plugins=(\n  git\n)/g' ~/.zshrc
    sed -i 's/git$/git\'$'\n  zsh-autosuggestions/g' ~/.zshrc
    sed -i 's/zsh-autosuggestions$/zsh-autosuggestions\'$'\n  zsh-syntax-highlighting/g' ~/.zshrc
} || {
    echo 'Failed to configure zsh plugins'
}

# hyper
if [ -x "$(command -v hyper)" ]; then
    echo "hyper installed"
else
    sudo dnf install hyper -y
fi;

# Snap package manager for Linux (kinda like brew)
if [ -x "$(command -v snap)" ]; then
    echo "Snap installed"
else
    sudo dnf install snapd -y
fi;
if [ -x "$(command -v snap-store)" ]; then
    echo "Snap Store installed"
else
    sudo ln -s /var/lib/snapd/snap /snap
    sudo dnf install snap-store -y
fi;

# Slack
if [ -x "$(command -v slack)" ]; then
    echo "Slack installed"
else
    snap install slack --classic
fi;

# VS Code
if [ -x "$(command -v code)" ]; then
    echo "VS Code installed"
else
    snap install code --classic
    code    --install-extension ms-azuretools.vscode-docker \
            --install-extension marcostazi.VS-code-vagrantfile \
            --install-extension mauve.terraform \
            --install-extension secanis.jenkinsfile-support \
            --install-extension formulahendry.code-runner \
            --install-extension mikestead.dotenv \
            --install-extension oderwat.indent-rainbow \
            --install-extension orta.vscode-jest \
            --install-extension jenkinsxio.vscode-jx-tools \
            --install-extension mathiasfrohlich.kotlin \
            --install-extension christian-kohler.npm-intellisense \
            --install-extension sujan.code-blue \
            --install-extension waderyan.gitblame \
            --install-extension ms-vscode.go \
            --install-extension in4margaret.compareit \
            --install-extension andys8.jest-snippets \
            --install-extension euskadi31.json-pretty-printer \
            --install-extension yatki.vscode-surround \
            --install-extension wmaurer.change-case
fi;

# N
if [ -x "$(command -v n)" ]; then
    echo "N - Node version manager installed with latest LTS of Node"
else
    curl -L https://git.io/n-install | bash
    source ~/.zshrc
fi;

# Meta
if [ -x "$(command -v meta)" ]; then
    echo "Meta installed"
else
    npm i -g meta
fi;

# Meta
if [ -x "$(command -v loop)" ]; then
    echo "Loop installed"
else
    npm i -g loop
fi;

# jq
if [ -x "$(command -v jq)" ]; then
    echo "jq installed"
else
    sudo dnf install jq -y
fi;

# JX
if [ -x "$(command -v jx)" ]; then
    echo "jx installed"
else
    curl -L "https://github.com/jenkins-x/jx/releases/download/$(curl --silent https://api.github.com/repos/jenkins-x/jx/releases/latest | jq -r '.tag_name')/jx-linux-amd64.tar.gz" | tar xzv "jx"
    echo "\nsource <(jx completion zsh)" >> ~/.zshrc
    echo "\nexport PATH=$HOME/.jx/bin:$PATH" >> ~/.zshrc
fi;

# docker
if [ -x "$(command -v docker)" ]; then
    echo "docker installed"
else
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager \
        --add-repo \
        https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install docker-ce docker-ce-cli containerd.io -y
    sudo systemctl start docker
    sudo groupadd docker
    sudo usermod -aG docker $ORIGINAL_USER
    echo "For permission changes to take effect, you must log out of your computer and log back in"
fi;

# docker-compose
if [ -x "$(command -v docker-compose)" ]; then
    echo "docker-compose installed"
else
    sudo dnf install docker-compose -y
fi;

# lazydocker
if [ -x "$(command -v lazydocker)" ]; then
    echo "lazydocker installed"
else
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi;

# kubectl
if [ -x "$(command -v kubectl)" ]; then
    echo "kubectl installed"
else
    sudo dnf install kubernetes-client
    echo "\nsource <(kubectl completion zsh)" >> ~/.zshrc
fi;

# brave-browser
if [ -x "$(command -v brave-browser)" ]; then
    echo "brave-browser installed"
else
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo dnf install brave-browser
fi;

# spotify
if [ -x "$(command -v spotify)" ]; then
    echo "spotify installed"
else
    sudo snap install spotify
fi;

# chrome
# google-chrome-stable
if [ -x "$(command -v google-chrome-stable)" ]; then
    echo "google-chrome-stable installed"
else
    sudo dnf config-manager --set-enabled google-chrome
    sudo dnf install google-chrome-stable
fi;

# safe
if [ -x "$(command -v safe)" ]; then
    echo "safe installed"
else
    curl -L https://github.com/starkandwayne/safe/releases/download/v1.3.4/safe-linux-amd64 --output ~/Downloads/safe-linux-amd64
    chmod +x ~/Downloads/safe-linux-amd64
    sudo mv ~/Downloads/safe-linux-amd64 /usr/bin/safe
fi;

# google cloud
if [ -x "$(command -v gcloud)" ]; then
    echo "google-cloud-sdk installed"
else
    sudo snap install google-cloud-sdk --classic
fi;

# terraform
if [ -x "$(command -v terraform)" ]; then
    echo "terraform installed"
else
    curl -L https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.9_linux_amd64.zip --output ~/Downloads/terraform.zip
    unzip ~/Downloads/terraform.zip -d ~/Downloads/terraform/
    chmod +x ~/Downloads/terraform/terraform
    sudo mv ~/Downloads/terraform/terraform /usr/bin/terraform
fi;
