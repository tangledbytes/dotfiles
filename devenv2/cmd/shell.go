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
	"os"

	"github.com/charmbracelet/log"
	"github.com/spf13/cobra"
	"github.com/tangledbytes/dotfiles/devenv2/pkg/shell"
)

// shellCmd represents the shell command
var shellCmd = &cobra.Command{
	Use:   "shell",
	Short: "Shell starts the a shell session to the devenv container",
	Args:  cobra.MaximumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		shellCmd := os.Getenv("SHELL")
		if len(args) > 0 {
			shellCmd = args[0]
		}

		if shellCmd == "" {
			log.Fatal("No $SHELL found and no argument provided")
		}

		forceTerm, _ := cmd.Flags().GetBool("force-term")
		dockerArgs := ""
		if forceTerm {
			dockerArgs += "-e TERM=tmux-256color"
		}
		err := shell.Exec("docker exec -it %s %s %s", dockerArgs, getEnvName(), shellCmd)
		if err != nil {
			log.Fatal("Failed to start a shell to devenv container", "err", err)
		}
	},
}

func init() {
	rootCmd.AddCommand(shellCmd)
	shellCmd.Flags().Bool("force-term", true, "Force setting up TERM environment variable")
}
