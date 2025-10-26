/*
Copyright © 2025 Utkarsh Srivastava

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"github.com/charmbracelet/log"
	"github.com/spf13/cobra"
	"github.com/tangledbytes/dotfiles/devenv2/pkg/docker"
	"github.com/tangledbytes/dotfiles/devenv2/pkg/shell"
)

const dockerfile = `
FROM fedora:latest

RUN dnf update -y && \
    dnf install -y @server-product vim less curl openssh-server @development-tools stow zsh sqlite3 fzf ripgrep zoxide && \
    dnf clean all

RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes

RUN useradd -ms /bin/zsh utkarsh
RUN echo 'utkarsh ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/utkarsh-nopasswd && \
    chmod 0440 /etc/sudoers.d/utkarsh-nopasswd
USER utkarsh
WORKDIR /home/utkarsh

RUN mkdir -p /home/utkarsh/{dev,bin} && \
	cd /home/utkarsh/dev && git clone https://github.com/tangledbytes/dotfiles.git && \
	cd /home/utkarsh/dev/dotfiles && \
	rm -rf /home/utkarsh/.zshrc && make setup

CMD [\"/usr/sbin/sleep\", \"36500d\"]
`

// startCmd represents the start command
var startCmd = &cobra.Command{
	Use:   "start",
	Short: "Start the devenv container",
	Args:  cobra.NoArgs,
	Run: func(cmd *cobra.Command, args []string) {
		status, err := docker.Status(getEnvName())
		if err != nil {
			log.Fatal("Failed to check status of devenv container:", "err", err)
		}

		if status == docker.Running {
			log.Info("Already Running")
			return
		}

		if status == docker.Stopped {
			log.Warn("Already exists, Restarting")
			_, _, err = shell.Run("docker container start %s", getEnvName())
			if err != nil {
				log.Fatal("Failed to start the pre-existing container")
			}

			log.Info("Started devenv container")
			return
		}

		log.Info("Image not found - Building")
		if err := docker.Build(dockerfile, arch, getEnvName()); err != nil {
			log.Fatal("devenv2 image failed -", err)
		}

		forceTerm, _ := cmd.Flags().GetBool("force-term")
		dockerArgs := ""
		if forceTerm {
			dockerArgs += "-e TERM=tmux-256color"
		}

		log.Info("Starting the devenv container")
		_, stderr, err := shell.Run("docker run -d --name %s %s %s", getEnvName(), dockerArgs, getEnvName())
		if err != nil {
			log.Fatal("Failed to start and create devenv container -", string(stderr))
		}

		log.Info("Started devenv container")
	},
}

func init() {
	rootCmd.AddCommand(startCmd)
	startCmd.Flags().Bool("force-term", true, "Force setting up TERM environment variable")
}
