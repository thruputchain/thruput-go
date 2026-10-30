# thruput-go

A Go workspace that pins a compatible set of the Thruput Go repositories
together.

Thruput's Go code lives in several repositories. This one carries no code of
its own: it holds each of them as a git submodule, and a `go.work` file that
builds [chuckd](https://github.com/thruputchain/chuckd) against the exact
[thruput-protocol-go](https://github.com/thruputchain/thruput-protocol-go) and
[lib-go](https://github.com/thruputchain/lib-go) commits it was last known to
compile with. The commit history is a log of which revisions have been built
together.

| Submodule | Contents |
|-----------|----------|
| `chuckd/` | The validator coordinator daemon. The only module `go.work` uses; it depends on the other two. |
| `protocol-go/` | Generated Go bindings for the Thruput protocol's XDR. Carries [thruput-protocol](https://github.com/thruputchain/thruput-protocol) as its own submodule. |
| `lib-go/` | Shared Go libraries. |

`go.work` has `replace` directives that point chuckd's dependencies on
`github.com/thruputchain/thruput-protocol-go` and
`github.com/thruputchain/lib-go` at the submodule checkouts, so the build
uses the pinned commits rather than whatever chuckd's `go.mod` would
otherwise resolve.

## Getting the source

```sh
git clone --recurse-submodules https://github.com/thruputchain/thruput-go
```

Or, in an existing clone:

```sh
git submodule update --init
```

Neither needs `--recursive`. `protocol-go/protocol` holds the protocol's XDR
definitions, but the generated bindings are committed to protocol-go, so
nothing here compiles it.

## Building

Requirements: Go (the version in `go.work`).

```sh
go build ./chuckd/...
go vet -composites=false ./chuckd/...
```

That is also all CI does. Running chuckd's test suite is chuckd's own job;
the question this repository answers is only whether the pinned revisions
still compile together.

## Updating a pin

Move a submodule to the commit you want, stage it, and commit with
`commit.sh`:

```sh
git -C protocol-go fetch origin main
git -C protocol-go checkout origin/main
git add protocol-go
./commit.sh
```

`commit.sh` writes the commit message in the form

```
protocol=<sha> chuckd=<sha> protocol-go=<sha> lib-go=<sha>
```

so each commit on `main` names the full set of revisions it pins. Keep that
format: it is what makes the history useful as a compatibility log.

A workflow, `auto-update.yml`, does the protocol-go half of this on demand:
it moves `protocol-go` to its `main`, opens a pull request, and lets it
auto-merge once CI confirms chuckd still compiles. If that goes red, chuckd
most likely needs a companion bump first.

## License

Apache-2.0. See [LICENSE](LICENSE).
