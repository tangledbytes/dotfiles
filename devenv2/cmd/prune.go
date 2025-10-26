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
	"github.com/tangledbytes/dotfiles/devenv2/pkg/shell"
)

// pruneCmd represents the prune command
var pruneCmd = &cobra.Command{
	Use:   "prune",
	Short: "Remove all the devenv data",
	Run: func(cmd *cobra.Command, args []string) {
		_, stderr, err := shell.Run("docker container rm -f %s", getEnvName())
		if err != nil {
			log.Fatal("failed to remove container", "err", string(stderr))
		}

		_, stderr, err = shell.Run("docker image rm %s", getEnvName())
		if err != nil {
			log.Fatal("failed to remove image", "err", string(stderr))
		}

		log.Info("Successfully Pruned")
	},
}

func init() {
	rootCmd.AddCommand(pruneCmd)
}
