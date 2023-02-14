install.packages("usethis")
usethis::use_git_config(user.name = "Crostin",
                        user.email = "cro.poletti@gmail.com")

usethis::use_git()

usethis::create_github_token()

gitcreds::gitcreds_set()


install.packages(c("admiral.test","heaven","admiral","dplyr","tidyr","metacore","metatools","xportr"))
install.packages("stringr")


library(haven)
library(admiral)
library(admiral.test)
library(dplyr)
library(tidyr)
library(metacore)
library(metatools)
library(xportr)
library(stringr)

adsl_spec <- readxl::read_xlsx("/cloud/project/metadata/specs.xlsx",sheet="Variables") %>%
filter(Dataset == "ADSL") %>%
dplyr::rename(type = "Data Type") %>%
  rlang::set_names(tolower) %>%
  mutate(format = str_to_lower(format))

## placeholder for origin=predecessor, use metatool::build_from_derived()
metacore <- spec_to_metacore("metadata/specs.xlsx", where_sep_sheet = FALSE, quiet = T)
# Get the specifications for the dataset we are currently building
adsl_spec <- metacore %>%
  select_dataset("ADSL")

dm <- convert_blanks_to_na(read_xpt(file.path("sdtm", "dm.xpt")))
ds <- convert_blanks_to_na(read_xpt(file.path("sdtm", "ds.xpt")))
ex <- convert_blanks_to_na(read_xpt(file.path("sdtm", "ex.xpt")))
qs <- convert_blanks_to_na(read_xpt(file.path("sdtm", "qs.xpt")))
sv <- convert_blanks_to_na(read_xpt(file.path("sdtm", "sv.xpt")))
vs <- convert_blanks_to_na(read_xpt(file.path("sdtm", "vs.xpt")))
sc <- convert_blanks_to_na(read_xpt(file.path("sdtm", "sc.xpt")))
mh <- convert_blanks_to_na(read_xpt(file.path("sdtm", "mh.xpt")))


#vector with pooled sites
pooled <- c("702","706","707","711","714","715","717")

#adsl variables from dm
adsl1 <- dm %>%
  mutate( SITEGR1 = case_when(
    SITEID %in% pooled ~ "900",
    TRUE ~ SITEID
  ),
  TRT01P = ARM,
  TRT01PN = case_when(
TRT01P == "Placebo" ~ 0,
TRT01P == "Xanomeline Low Dose" ~ 54,
TRT01P == "Xanomeline High Dose" ~ 81
  ),
TRT01A = TRT01P,
TRT01AN = TRT01PN,
AGEGR1N = case_when(
  AGE < 65 ~ 1,
  AGE >= 65 & AGE <= 80 ~ 2,
  AGE > 80 ~ 3
),
AGEGR1 = case_when(
  AGE < 65 ~ "<65",
  between(AGE,65,80) ~ "65-80",
  AGE > 80 ~ ">80"
),
RACEN = case_when(
  RACE == "AMERICAN INDIAN OR ALASKA NATIVE" ~ 1,
  RACE == "ASIAN" ~ 2,
  RACE == "BLACK OR AFRICAN AMERICAN" ~ 3,
  RACE == "NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER" ~ 5,
  RACE == "WHITE" ~ 6
))


#TRTSDT: SV.SVSTDTC when SV.VISITNUM=3, converted to SAS date
svt <- sv %>%
  filter(VISITNUM == 3 ) %>%
  mutate(TRTSDT = ymd(SVSTDTC)) %>%





