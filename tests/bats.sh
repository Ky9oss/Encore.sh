#!/usr/bin/env bats

# @test "addition using bc" {
#   result="$(echo 2+2 | bc)"
#   [ "$result" -eq 4 ]
# }
#
# @test "addition using dc" {
#   result="$(echo 2 2+p | dc)"
#   [ "$result" -eq 4 ]
# }

SOURCE_DIR="$(dirname "$BATS_TEST_FILENAME")"

DOWNLOAD_FILEPATH="${SOURCE_DIR}/../utils/download.sh"
source "$DOWNLOAD_FILEPATH"

@test "check http url" {
    t=$(check_url "http://baidu.com")
    [ "$t" = "matched" ]
}

@test "check https url" {
    t=$(check_url "https://baidu.com/123")
    [ "$t" = "matched" ]
}

@test "check_executable: all commands exist" {
    t=$(check_executable whoami which curl wget proxychains)
}

@test "check_executable: some commands do not exist ( wget2 wowo )" {
    run check_executable whoami which curl wget wget2 proxychains wowo
    [ "$status" -eq 1 ]
}

@test "download test 1" {
    tar() {
        # for i in "$@"; do echo "tar: $i"; done
        printf "tar: %s" "$@"
    }

    proxychains() {
        echo "wget: $3"
        cat <<'EOF'

   2026-03-12 20:50:09 (5.43 KB/s) - ‘lib-2.5.6.tar.gz’ saved [833/833]

EOF
    }

    t=$(download "http://google.com")
    
    # echo $t >&3
    [[ "$t" =~ "-zxf" ]]
}

@test "download test 2" {
    tar() {
        # for i in "$@"; do echo "tar: $i"; done
        printf "tar: %s" "$@"
    }

    proxychains() {
        echo "wget: $3"
        cat <<'EOF'

   2026-03-12 20:50:09 (5.43 KB/s) - ‘lib-2.5.6.tar.xz’ saved [833/833]

EOF
    }

    t=$(download "http://google.com")
    
    # echo $t >&3
    # [[ "$t" =~ "xf" && ! "$t" =~ "zxf" ]]
    [[ "$t" =~ "-xf" ]]
}

@test "download test 3" {
    tar() {
        # for i in "$@"; do echo "tar: $i"; done
        printf "tar: %s" "$@"
    }

    proxychains() {
        echo "wget: $3"
        cat <<'EOF'

   2026-03-12 20:50:09 (5.43 KB/s) - ‘lib-2.5.6’ saved [833/833]

EOF
    }

    t=$(download "http://google.com")
    
    # echo $t >&3
    [[ ! "$t" =~ "-xf" && ! "$t" =~ "-zxf" ]]
}
