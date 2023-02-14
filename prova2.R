"ciao Naza"
install.packages("usethis")

usethis::use_git_config(user.name = "Crostin",
                        user.email = "cro.poletti@gmail.com")
usethis::use_git()

usethis::create_github_token()

gitcreds::gitcreds_set()

"prova prova check check sempre proviamo"
