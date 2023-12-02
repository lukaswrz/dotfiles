#!/usr/bin/env python

from argparse import ArgumentParser
from sys import argv, stderr
from subprocess import run as run_raw
from shlex import quote
from os import environ
from pathlib import Path
from textwrap import dedent


if __name__ == "__main__":
    parser = ArgumentParser()

    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="print verbose output",
    )

    parser.add_argument("choices", nargs="*")

    progargs = parser.parse_args(argv[1:])

    def verbose(*args, **kwargs):
        if progargs.verbose:
            return print(*args, **kwargs)

    def run(*args, **kwargs):
        verbose(
            " ".join([quote(arg) for arg in (kwargs.get("args", args[0]))]),
            file=stderr,
        )

        return run_raw(*args, **kwargs)

    def chosen(choice: str) -> bool:
        if not progargs.choices or choice in progargs.choices:
            verbose(choice)
            return True

        return False

    if chosen("git"):
        for k, v in {
            "user.name": "Lukas Wurzinger",
            "user.email": "lukas@wrz.one",
            "color.ui": "true",
            "init.defaultBranch": "main",
            "merge.conflictstyle": "diff3",
        }.items():
            run(["git", "config", "--global", "--", k, v])

        result = run(
            ["git", "config", "--global", "--get", "core.excludesfile"],
            capture_output=True,
        )
        if result.returncode == 0:
            gitignore = result.stdout.decode()
            if gitignore[-1] == "\n":
                gitignore = gitignore[:-1]
            gitignore = Path(gitignore)
            if gitignore.is_file():
                gitignore = None
        else:
            gitignore = (
                Path(environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
                / "git"
                / "ignore"
            )
            if gitignore.is_file():
                gitignore = None
            else:
                gitignore.parent.mkdir(parents=True, exist_ok=True)

        if gitignore is not None:
            gitignore.write_text(dedent("""\
                .idea/
                .vscode/
                .iml
                *.sublime-workspace

                node_modules/
                vendor/

                log/
                *.log

                __pycache__/
                zig-cache/

                *.com
                *.class
                *.dll
                *.exe
                *.o
                *.so
                *.pyc
                *.pyo

                *.7z
                *.dmg
                *.gz
                *.iso
                *.jar
                *.rar
                *.tar
                *.zip
                *.msi

                *.sqlite
                *.sqlite3
                *.db
                *.db3
                *.s3db
                *.sl3
                *.rdb

                *.bak
                *.swp
                *.swo
                *~
                *#

                zig-out/
            """))

    if chosen("plasma"):
        parent = (
            Path(environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
            / "plasma-workspace"
            / "env"
        )

        for k, v in {
            "askpass.sh": 'export SUDO_ASKPASS="$HOME/.local/bin/sudoaskpass"\n',
            "editor.sh": "export EDITOR=helix\nexport VISUAL=helix\n",
            "firefox.sh": "export MOZ_USE_XINPUT2=1\n",
            "path.sh": 'export PATH="$HOME/.local/bin:$PATH"\n',
            "steam.sh": "export GDK_SCALE=1\n",
        }.items():
            script = parent / k
            if script.exists(follow_symlinks=False):
                script.unlink()
            script.parent.mkdir(parents=True, exist_ok=True)
            script.write_text(v)

        sudoaskpass = Path.home() / '.local' / 'bin' / 'sudoaskpass'
        if sudoaskpass.exists(follow_symlinks=False):
            sudoaskpass.unlink()
        sudoaskpass.parent.mkdir(parents=True, exist_ok=True)
        sudoaskpass.touch(mode=0o755)
        sudoaskpass.write_text(dedent("""\
            #!/usr/bin/env bash
            exec kdialog --password Askpass
        """))

    if chosen("mpv"):
        mpv_parent = Path.home() / ".var" / "app" / "io.mpv.Mpv"
        if mpv_parent.is_dir():
            mpv_conf = mpv_parent / "config" / "mpv" / "mpv.conf"
            if not mpv_conf.exists(follow_symlinks=False):
                mpv_conf.parent.mkdir(parents=True, exist_ok=True)
                mpv_conf.write_text(dedent("""\
                    force-window=immediate
                    keep-open=yes
                    save-position-on-quit=yes

                    screenshot-template="%f_%wH%wM%wS.%wT"

                    scale=ewa_lanczossharp
                    cscale=ewa_lanczossharp
                    tscale=oversample

                    interpolation=yes
                    video-sync=display-resample
                    vo=gpu
                    profile=gpu-hq
                """))

    if chosen("readline"):
        inputrc = Path.home() / ".inputrc"
        if not inputrc.exists(follow_symlinks=False):
            inputrc.write_text(dedent("""\
                set editing-mode vi
                set completion-ignore-case on
                set enable-bracketed-paste on

                $if mode=vi
                set show-mode-in-prompt on
                set keymap vi-command
                Control-l: clear-screen
                Control-a: beginning-of-line
                set keymap vi-insert
                Control-l: clear-screen
                Control-a: beginning-of-line
                $endif
            """))

    if chosen("fish"):
        fish_config = (
            Path(environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
            / "fish"
            / "config.fish"
        )
        if not fish_config.exists(follow_symlinks=False):
            fish_config.parent.mkdir(parents=True, exist_ok=True)
            fish_config.symlink_to(Path.cwd() / "config.fish")

    if chosen("bash"):
        bashrc = Path.home() / ".bashrc"
        if not bashrc.exists(follow_symlinks=False):
            bashrc.parent.mkdir(parents=True, exist_ok=True)
            bashrc.symlink_to(Path.cwd() / "bashrc")

    if chosen("ssh"):
        ssh_config = Path.home() / '.ssh' / 'config'
        if not ssh_config.exists(follow_symlinks=False):
            ssh_config.parent.mkdir(parents=True, exist_ok=True)
            ssh_config.write_text(dedent("""\
                Host *
                ServerAliveInterval 60
                Compression yes
            """))

    if chosen("firefox"):
        parent = (
            Path.home()
            / ".var"
            / "app"
            / "org.mozilla.firefox"
            / ".mozilla"
            / "firefox"
        )

        for pattern in ["*.default", "*.default-release"]:
            for profile in parent.glob(pattern):
                userjs = profile / "user.js"

                if not userjs.exists(follow_symlinks=False):
                    userjs.write_text(dedent("""\
                        user_pref('signon.prefillForms', false);
                        user_pref('signon.rememberSignons', false);
                        user_pref('privacy.webrtc.legacyGlobalIndicator', false);
                        user_pref('browser.compactmode.show', true);
                        user_pref('toolkit.legacyUserProfileCustomizations.stylesheets', true);
                        user_pref('signon.autofillForms', false);
                        user_pref('signon.formlessCapture.enabled', false);
                        user_pref('browser.formfill.enable', false);
                        user_pref('extensions.pocket.enabled', false);
                        user_pref('browser.newtabpage.activity-stream.showSponsored', false);
                        user_pref('browser.newtabpage.activity-stream.showSponsoredTopSites', false);
                        user_pref('browser.newtabpage.activity-stream.feeds.section.topstories', false);
                        user_pref('browser.newtabpage.activity-stream.feeds.topsites', false);
                        user_pref('browser.newtabpage.activity-stream.section.highlights.includeBookmarks', false);
                        user_pref('browser.newtabpage.activity-stream.section.highlights.includeDownloads', false);
                        user_pref('browser.newtabpage.activity-stream.section.highlights.includeVisited', false);
                        user_pref('media.ffmpeg.vaapi.enabled', true);
                        user_pref('media.rdd-vpx.enabled', true);
                        user_pref('toolkit.telemetry.unified', false);
                        user_pref('toolkit.telemetry.enabled', false);
                        user_pref('toolkit.telemetry.server', 'data:,');
                        user_pref('toolkit.telemetry.archive.enabled', false);
                        user_pref('toolkit.telemetry.newProfilePing.enabled', false);
                        user_pref('toolkit.telemetry.shutdownPingSender.enabled', false);
                        user_pref('toolkit.telemetry.updatePing.enabled', false);
                        user_pref('toolkit.telemetry.bhrPing.enabled', false);
                        user_pref('toolkit.telemetry.firstShutdownPing.enabled', false);
                        user_pref('toolkit.telemetry.coverage.opt-out', true);
                        user_pref('toolkit.coverage.opt-out', true);
                        user_pref('toolkit.coverage.endpoint.base', '');
                        user_pref('browser.ping-centre.telemetry', false);
                        user_pref('app.shield.optoutstudies.enabled', false);
                        user_pref('app.normandy.enabled', false);
                        user_pref('app.normandy.api_url', '');
                        user_pref('breakpad.reportURL', '');
                        user_pref('browser.tabs.crashReporting.sendReport', false);
                        user_pref('browser.crashReports.unsubmittedCheck.autoSubmit2', false);
                        user_pref("network.http.referer.XOriginPolicy", 1);
                        user_pref("network.http.referer.XOriginTrimmingPolicy", 0);
                    """))

    if chosen("helix"):
        helix_config = (
            Path(environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
            / "helix" / "config.toml"
        )

        if helix_config.exists(follow_symlinks=False):
            helix_config.unlink()
        else:
            helix_config.parent.mkdir(parents=True, exist_ok=True)
        helix_config.symlink_to(Path.cwd() / "config.toml")
