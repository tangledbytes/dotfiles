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
	"fmt"

	"github.com/charmbracelet/log"
	"github.com/spf13/cobra"
	"github.com/tangledbytes/dotfiles/devenv2/pkg/shell"
)

// statusCmd represents the status command
var statusCmd = &cobra.Command{
	Use:   "status",
	Short: "Prints the status of all the devenv containers",
	Run: func(cmd *cobra.Command, args []string) {
		stdout, stderr, err := shell.Run("docker container ls --filter \"name=%s*\"", envNamePrefix)
		if err != nil {
			log.Fatal("failed to get container status", "err", string(stderr))
		}

		fmt.Print(string(stdout))
	},
}

func init() {
	rootCmd.AddCommand(statusCmd)
}
