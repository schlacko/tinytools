#!/bin/bash

# --- BEÁLLÍTÁSOK ---
DEFAULT_IMG="$HOME/.config/backgrounds/00_minimal_black_arch.png"
TMP_IMG="/tmp/i3_wallpaper.jpg"
INFO_FILE="/tmp/current_wallpaper_info.txt"
RESOLUTION_WIDTH="1600"
API_URL="https://commons.wikimedia.org/w/api.php"

# --- 1. INTERNETKAPCSOLAT ELLENŐRZÉSE ---
if ! ping -q -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
  feh --bg-fill "$DEFAULT_IMG"
  echo "Nincs internet." >"$INFO_FILE"
  exit 0
fi

# --- 2. URL LISTA ---
URL_LIST=$(
  cat <<'EOF'
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGebel_Ciantar.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFUNGI.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARitson%27s_Force_Lake_District_2021_01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_Owlet_Trio%2C_A_Glimpse_of_Young_Wisdom.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_waterfall_in_R%C3%B6ttle.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABoats_at_shore_of_Brahmaputra_3.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_family_of_Gentle_Elephant.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AA_cold_morning.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AViscacha_sits_on_rocks_in_the_Bolivian_altiplano.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMandarine_on_Fire.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AA_pair_of_Bornean_partridges.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALe_Babouin.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASearching_for_the_future.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASomorika_hill_edo_state_441.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AHoopoe_in_grass.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKukaj_rruges_per_tek_maja_e_Rosit.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_apex_of_a_plant.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARiver_Densu_%40_Weija_dam.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_migration.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFocus%2C_Contemplate%2C_Connect%21_Merging_with_nature_in_the_nature_park_on_the_Island_of_Cres%2C_near_Beli_Prirodni_Park%2C_Croatia.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A047_Monk_parakeets_flying_in_Encontro_das_%C3%81guas_State_Park_Photo_by_Giles_Laurent.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALikokolo.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASteps_into_solitude.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMount_Kinabalu_South_Peak.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALocal_Fisherman_in_Tayud.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ANature_of_Pirshagi_24.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AUncanard.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACitrine_wagtail_trying_to_catcha_damselfly.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AStriped_blue_crow_butterfly.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AWaldkiefer_mit_Knospen_im_FFH-Gebiet_Heidefl%C3%A4chen_und_Lohw%C3%A4lder_n%C3%B6rdlich_von_M%C3%BCnchen.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFleur_de_la_passion_du_christ_3.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AIl-Qolla_l-Bajda_4.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A003_Ringed_kingfisher_flying_with_a_fish_in_Encontro_das_%C3%81guas_State_Park_Photo_by_Giles_Laurent.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ADomestic_Canary_babies.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACaqacuq%C3%A7ay_2022_%281%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AChantons.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGateway_out_of_the_Ogwen.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AParque_estadual_ilha_do_cardoso-THIAGO_CAMPI_02.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACascata_do_Po%C3%A7o_do_Inferno.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAgahungarema.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AHarmoni_Alam_dan_Kehidupan_di_Persawahan_Taba_Tembilang._Pagi_yang_Menyatu_antara_Cahaya%2C_Gunung%2C_Sungai%2C_dan_Kerja_Keras_Petani.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKhizy_mountains.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABee-eater_greeting_the_sunset.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APapilio_machaon_-_%CE%9A%CE%AC%CE%BC%CF%80%CE%B9%CE%B1.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACaplja_u_letu.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMonitor_lizard_swallows_Uromastyx_in_Kuwait.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%97%D0%B0%D1%94%D1%86%D1%8C_%D1%81%D1%96%D1%80%D0%B8%D0%B9_%D1%83_%D0%93%D0%B0%D0%BB%D0%B8%D1%86%D1%8C%D0%BA%D0%BE%D0%BC%D1%83_%D0%B1%D0%BE%D1%82%D0%B0%D0%BD%D1%96%D1%87%D0%BD%D0%BE%D0%BC%D1%83_%D1%81%D0%B0%D0%B4%D1%83_%D0%BB%D1%96%D0%BA%D0%B0%D1%80%D1%81%D1%8C%D0%BA%D0%B8%D1%85_%D1%80%D0%BE%D1%81%D0%BB%D0%B8%D0%BD.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAt_R%C3%A5%C3%A5n_near_Helsingborg.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABlack_and_white_Helen_%28Tabin_Wildlife_Reserve%2C_April_2025%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AHyalinobatrachium_carlesvilai%2C_National_Park_Carrasco.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APine_Island.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D9%88%D8%B2%D8%BA%D8%A9_%D8%B5%D8%AD%D8%B1%D8%A7%D9%88%D9%8A%D8%A9.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3Alossy-page1-960px-DSC_6197.tif.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APantai_Lempuyang%2C_surga_tersembunyi_di_pelosok_Situbondo.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3Alossy-page1-960px-Kl%C3%A1%C5%A1ter_Tepl%C3%A1.tif.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AND-05430_Baumgruppe_am_Bildstock_4-2025_%281%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APest%C5%99enka_vosi%C4%8Dka.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AVark%C3%AB_n%C3%AB_Drilon.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%22Leap._Believe._Become.%22.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A004_Great_horned_owl_under_a_Pink_Ip%C3%AA_tree_in_Encontro_das_%C3%81guas_State_Park_Photo_by_Giles_Laurent.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACalmness_of_hutan_lipur_kanching.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACoq_d%27Haiti.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ADesove_de_tatarugas_en_el_rio_It%C3%A9nez.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABee_collecting_nectar_from_flowers.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACHATAIGNE_D%C3%A9c.2025.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKeanggunan_Merak_Hijau_Jawa.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGeotop_und_Naturdenkmal_Schleierf%C3%A4lle_und_H%C3%B6hle_im_Kalktuff_an_der_Ammer_SE_von_Wildsteig.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMultitude_in_Reef.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATelanthophora.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%91%D0%B0%D0%B1%D0%BE%D1%87%D0%BA%D0%B0_%D0%BF%D0%B5%D1%80%D0%BB%D0%B0%D0%BC%D1%83%D1%82%D1%80%D0%BE%D0%B2%D0%BA%D0%B0_%D0%9F%D0%B0%D0%BD%D0%B4%D0%BE%D1%80%D0%B0.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACape_Buffalo_with_Oxpeckers.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AJahra_Nature_Reserve_in_Kuwait.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAnti10.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACommon_Blue_Damselfly_-_Enallagma_cyathigerum_12.06.2024.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APaisaje_de_Socma%2C_Ollantaytambo_09.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APaisajes_de_Huilloc%2C_Ollantaytambo_18.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABEE_in_asswan.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALapin_en_cage.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMount_Pangaion%2C_Mt_Paggaio_or_Paggeo%2C_winter_landscape%2C_horizontal_image%2C_Nikisiani%2C_Greece.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APair_of_geese_in_the_foreground_with_a_fisherman%E2%80%99s_boat_in_the_distance_on_Lake_Shkod%C3%ABr.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APapillon_%C3%A0_tanguieta.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKabompo_river.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATata_illampu.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AV%C3%A4stra_Getter%C3%B6ns_naturreservat%2C_salta_klippor.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMagia_Invernosa_do_C%C3%A2ntaro_Magro_e_do_PNSE.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AOwl_from_asswan.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9F%D0%B0%D0%BD%D0%BE%D1%80%D0%B0%D0%BC%D0%B0_%D1%81_%D1%8E%D0%B6%D0%BD%D0%BE%D0%B9_%D1%81%D1%82%D0%BE%D1%80%D0%BE%D0%BD%D1%8B_%D0%BF%D0%B8%D0%BA%D0%B0_%D0%A1%D0%BE%D0%B2%D0%B5%D1%82%D0%BE%D0%B2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKINGFISHRS_IN_JAHRA_KUWAIT.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATorre_Chianca_-_Bacino_del_fiume_Idume.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9C%D1%83%D1%85%D0%BE%D0%BC%D0%BE%D1%80_%D0%BA%D1%80%D0%B0%D1%81%D0%BD%D1%8B%D0%B9_Amanita_muscaria_3.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALe_caratteristiche_barchette_a_Lesina.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APose_of_the_mongoose.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AS%C3%A5ngsvansfamiljen_i_Vrinnevi_v%C3%A5tmark.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATravelers_plan_their_day_very_early_in_Oman.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAlas_extendidas.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AArachnanthus_Sarsi_in_Church_Bay%2C_Rathlin_Island.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AOuverture_du_barrage_Malleg.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARosni%C4%8Dka_5901.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AArmenian_gull_8.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASunshine_of_the_darkness.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATataruga_%28Podocnemis_expansa%29_desovando_al_amanecer.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAtlantic_Puffin%2C_Skomer_Island.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABrown_Throated_Sunbird_-_Female.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACHKO_Brdy_Listonoh_letn%C3%AD.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AUn_Bulbul_boutin_qui_se_nourrit_d%27un_Jamrosat_7.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%92%D0%BE%D0%B4%D0%BE%D0%BF%D0%B0%D0%B4_%D0%9A%D1%83%D0%BB%D0%B0%D1%81%D1%8C%D1%8F.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABridges_of_Ross_County_Clare_2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACaqacuq%C3%A7ay_2022_%282%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMushroom_rock_Gozo.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APhyllomedusa_camba%2C_Tipnis%2C_2025_06.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASchwebfliege-JR-T3-I127-2024-08-04.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AJuvenile_cuttlefish_near_St_Paul%E2%80%99s_Islands%2C_Malta.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AStillness_in_the_Firelight.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASitta_europaea%2C_commonly_known_as_the_Eurasian_nuthatch%2C_observed_in_Germia_Park%2C_Pristina%2C_Kosovo.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9E%D0%B4%D1%80%D0%B0%D0%B7.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFast_Waterfall.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALe_Petit_monarque%2C_Tangui%C3%A9ta%2C_Nord_B%C3%A9nin_F%C3%A9vrier_2024.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APlage_de_kerkenah_couch%C3%A9_de_soleil.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AHsinchu_City_Coastal_Wildlife_Refuge_by_Kathryn001.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALago_Titicaca_visto_desde_el_Apu_Pokopaka_en_Huancan%C3%A9.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ANear_GoyGol_lake_3.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASunrise_On_The_Dunes.png
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALobster_Moth_caterpillar.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9F%D0%B0%D1%83%D0%BA_%D0%B8_%D1%81%D0%BA%D0%B0%D0%BA%D0%B0%D0%B2%D0%B0%D1%86.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAnimals_in_Zambia_at_a_park_08.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AWild_Crocus_flowers_in_full_bloom_in_the_Sharr_Mountains.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AHuants%C3%A1n%2C_cara_este%2C_quebrada_Alhuina%2C_Parque_nacional_Huascar%C3%A1n_10.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMbinzo.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ANemoptera_sinuata_in_Khosrov_Forest_State_Reserve.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGlacier_valley_in_Khan_Tengri_Nature_Park%2C_Tien_Shan.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMan_herding_a_flock_of_sheep_in_the_Sharr_Mountains.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AP%C3%ABrroi_i_Holt%C3%ABs.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThonningia_Sanguine_dans_la_r%C3%A9serve_de_faune_de_malfakasa_04.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMadygen_Sary-Tash_Valley_14.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A7%D0%B5%D0%BF%D1%83%D1%80%D0%B8_%D0%B2%D0%B5%D0%BB%D0%B8%D0%BA%D1%96_%D1%82%D0%B0_%D0%BC%D0%B0%D0%BB%D1%96.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AIl_Bramito_del_Cervo.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACentro_poblado_de_Socma%2C_Ollantaytambo_06.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9F%D0%B0%D0%BD%D0%BE%D1%80%D0%B0%D0%BC%D0%B0_%D0%BD%D0%B0_%D0%B7%D0%B8%D0%BC%D0%BD%D0%B8%D0%B5_%D0%B3%D0%BE%D1%80%D1%8B.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABaby_Cygnet.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AJahra_Nature_Reserve_in_Kuwait_-_Aerial_photography.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AWanze-JR-T3-I127-2025-04-11.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A1%D0%B0%D1%80%D0%BD%D0%B0_%D1%81%D0%B5%D1%80%D0%B5%D0%B4_%D1%82%D1%80%D0%B0%D0%B2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AA_Tiny_World_-_Ladybug_on_Mushrooms.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AArbres_majestueux_de_la_for%C3%AAt_de_GNINZOUNMIN.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACh%C3%AAne_p%C3%A9doncul%C3%A9_Oued_Zen.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARugova_Canion.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATrapped_YMS_9025.png
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%C2%B0_Wegerich_Scheckenfalter_%C2%B0.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9C%D0%B0%D1%85%D0%B0%D0%BE%D0%BD_%D0%BF%D0%BE%D1%80%D1%8F%D0%B4_%D0%B7_%D1%81%D0%BE%D0%BD%D1%86%D0%B5%D0%BC.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A7%D0%B8%D0%B3%D0%BE%D1%82%D0%B0%2C_%D1%83%D1%81%D0%B0%D0%BC%D1%99%D0%B5%D0%BD%D0%B0_%D0%BA%D1%83%D1%9B%D0%B8%D1%86%D0%B0.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D9%81%D9%84%D8%A7%D9%85%D9%86%D8%AC%D9%88_%D9%8A%D8%A8%D8%AD%D8%AB_%D8%B9%D9%86_%D8%A7%D9%84%D8%B7%D8%B9%D8%A7%D9%85.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AA_New_Cycle_Begins.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATuh%C3%A1_zima.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AWiedehopf_Futter%C3%BCbergabe.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A1%D0%B8%D0%B2%D0%B0_%D0%92%D0%B5%D1%82%D1%80%D1%83%D1%88%D0%BA%D0%B0.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABurntForrestBohemianSwitzerland.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ADuch_lesa.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_moment_of_the_attack.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFlamingo_Divjak%C3%AB.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMadygen_Sary-Tash_Valley_9.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APurple_heron_in_Pateira_de_Fermentelos.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABorrowdale_Valley_and_Scafell_Pike_range%2C_Lake_District_National_Park%2C_England.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASerenity_in_Flight.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFried-egg_Jellyfish_%28Phacellophora%29_at_%C4%8Airkewwa_Marine_Park.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AL%27oiseau_de_la_Ruvubu.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAerial_view_of_Ilorin_Central_Mosque_and_the_Emir%27s_palace.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACapung_Jarum_Sangihe_%28Protosticta_rozendalorum%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALovers_of_nature.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASwallowtail_Butterfly_-_13_June_2025%2C_Wied_Ghollieqa.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AA_fisherman_returns_in_his_boat_at_sunset_on_Lake_Shkod%C3%ABr.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAnthus_spinoletta_on_the_snow.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_Gecko%27s_trail.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AVoilier_des_Citronniers%2C_Dassari_%28Mat%C3%A9ri%29%2C_Nord_B%C3%A9nin%2C_Mai_2025.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAkanyoni_keza.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALion%E2%80%99s_mane_jellyfish_in_Church_Bay%2C_Rathlin_Island%2C_Northern_Ireland.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMardakan.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARafflesia_Buds_-_Ranau%2C_Sabah%2C_Malaysia.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACrocodile_34.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGuinea_Fowl_Al_Qudra_Lake.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALago_Federa.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APicathartes_or_rockfowl.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARainbow_in_Lusaka_06.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASouimanga_%C3%A0_Tangui%C3%A9ta.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9F%D0%B5%D0%B9%D0%B7%D0%B0%D0%B6%D0%B8_%D0%A7%D0%B0%D1%80%D1%8B%D0%BD%D1%81%D0%BA%D0%BE%D0%B3%D0%BE_%D0%BA%D0%B0%D0%BD%D1%8C%D0%BE%D0%BD%D0%B0_5.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AVelebitske_kreacije.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGreat_Egret_at_sundarban.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%CE%A3%CE%B1%CE%BB%CE%B9%CE%B3%CE%BA%CE%AC%CF%81%CE%B9_%CF%83%CF%84%CE%B7%CE%BD_%CF%80%CE%B5%CF%81%CE%B9%CE%BF%CF%87%CE%AE_%CF%84%CE%B7%CF%82_%CE%BB%CE%AF%CE%BC%CE%BD%CE%B7%CF%82_%CE%A0%CE%BB%CE%B1%CF%83%CF%84%CE%AE%CF%81%CE%B1.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AS_tou_nejkvalitn%C4%9Bj%C5%A1%C3%AD_potravou_pro_ml%C3%A1%C4%8Fata.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AShoushan_Emily_01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFleur_Sauvage_2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALibellule_%C3%A0_Tanguieta_au_nord_B%C3%A9nin.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALorestan_5.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ADarbat_Jaafar_Waterfall_%281%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGreen_Metallic_Weevil.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AOtus_scops_botanical_garden.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D8%B5%D8%AD%D8%B1%D8%A7%D8%A1_%D8%AD%D9%85%D9%8A%D8%AB%D8%B1%D8%A9_10.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AWhite-throated_Kingfisher_Taman_Botani_Perdana_KL.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGoyGol_lake.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AEmperor_Dragonfly_%28Anax_imperator%29_Mid_Air.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%CE%9B%CE%B9%CE%BC%CE%BD%CE%BF%CE%B8%CE%AC%CE%BB%CE%B1%CF%83%CF%83%CE%B1_%CE%9A%CE%B1%CE%BB%CE%BF%CF%87%CF%89%CF%81%CE%AF%CE%BF%CF%85.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D8%A7%D9%84%D8%A8%D9%8A%D8%AD%D8%B1%D9%87_%D8%A7%D9%84%D9%85%D8%B3%D8%AD%D9%88%D8%B1%D9%87_%D9%81%D9%8A_%D8%A7%D9%84%D9%81%D9%8A%D9%88%D9%85.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACerro_Pelado%2C_Sierra_Nevada.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASkink_in_Ashtarak%2C_Armenia.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALes_Bufles_de_la_Ruvubu.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A001_Marsh_deer_and_Pink_Ip%C3%AA_tree_in_Encontro_das_%C3%81guas_State_Park_Photo_by_Giles_Laurent.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARed_Deer_Cervus_Elaphus_in_Richmond_Park_2025_02.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFanal_2024.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AJedine%C4%8Dnost_okam%C5%BEiku.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALa_nature_et_les_animaux_06.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A20250531_Vista_del_valle_de_P%C3%ADsac.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACosta_de_Odeceixe.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATow_mating_butteflies_in_Khoja_Gur_Gur_Ota_175.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%94%D0%B8%D0%BA%D1%96_%D0%B3%D1%83%D1%81%D0%B8_%D0%BD%D0%B0_%D1%80%D1%96%D1%87%D0%BA%D0%BE%D1%8E.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AG%C3%B6yg%C3%B6l_20220730_%281%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMarmorbruket.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9A%D1%8B%D1%80%D0%B3%D1%8B%D0%B7-%D0%90%D1%82%D0%B0_%D0%BD%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9_%D0%BF%D0%B0%D1%80%D0%BA_1.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AEurasian_Hoopoe_2024_May.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFlamingo_in_jahra_area.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALac_Rad%C3%A8s_M%C3%A9liane_le_matin.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9D%D0%BE%D0%B2%D0%B8%D0%B9_%D1%81%D0%B2%D1%96%D1%82%D0%B0%D0%BD%D0%BE%D0%BA._%D0%9F%D0%B0%D0%BD%D0%BE%D1%80%D0%B0%D0%BC%D0%B0.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A6%D0%B2%D0%B5%D1%82%D1%83%D1%89%D0%B0%D1%8F_%D0%B0%D0%BB%D1%8B%D1%87%D0%B0.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMaja_e_Ujezes_dhe_Mali_Shkelzen.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASunset_captured_on_Dubai_Dunes_%28Wide_Angle%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A1%D0%B2%D1%96%D1%82%D0%B0%D0%BD%D0%BA%D0%BE%D0%B2%D1%96_%D0%BA%D0%BE%D0%BB%D1%8C%D0%BE%D1%80%D0%B8.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFierce_Encounter_at_Ranthambore.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ADa%C4%9F%2CQusar_rayonu.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AShafro_Farms%2C_Maala%2C_Namwala_Zambia.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATrypoxylus_dichotomus_tsunobosonis.LTP.png
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D8%AC%D8%B2%D9%8A%D8%B1%D8%A9_%D8%A7%D9%84%D8%B5%D9%8A%D8%A7%D8%AF%D9%8A%D9%86_%D8%A8%D8%B4%D9%84%D8%A7%D8%AA%D9%8A%D9%86_30.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A7%D0%B5%D0%BF%D1%83%D1%80%D0%B0_%D0%B2%D0%B5%D0%BB%D0%B8%D0%BA%D0%B04.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACurious_Owlets.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APluies_de_feu.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AWasdale_Head_from_Great_Gable_2022_01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKrishansar_Lake%2C_Sonmarg%2C_Kashmir_valley%2C_India.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AArabian_Gazel.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKapurpurawan_Rock_Formation_Ilocos.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARencontre_cile_terre.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AWhen_Roads_Become_Rivers_3.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGrand_cormoran_en_d%C3%A9collage.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALiuwa_Plains.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AEye_of_Wisdom.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%97%D0%B0_%D0%BD%D0%B5%D0%BA%D0%BE%D0%B3_%D1%98%D1%83%D1%82%D1%80%D0%BE_%D0%BD%D0%B0_%D0%A4%D1%80%D1%83%D1%88%D0%BA%D0%BE%D1%98_%D0%B3%D0%BE%D1%80%D0%B8.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D8%A7%D9%86%D8%B9%D9%83%D8%A7%D8%B3_%D8%A7%D8%A8%D9%88_%D8%A7%D9%84%D9%85%D8%BA%D8%A7%D8%B2%D9%84.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMelitaea_didyma_2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAu_bord_du_lac_Togo_avec_une_vue_sur_le_pont_Adido_%C3%A0_l%27embouchure_01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABAMBOO_STICKS.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AParque_Nacional_da_Chapada_Diamantina_-_Maria_Bosetti_%2812%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAle_Stenar_Sk%C3%A5ne_2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AParque_nacional_serra_da_capivara-THIAGO_CAMPI-03.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AResilience_in_Deep_Waters_2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%C5%A0%C3%ADdlo_r%C3%A1kosn%C3%AD.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A1%D0%B2%D1%96%D1%82%D0%B0%D0%BD%D0%BE%D0%BA_%D1%83_%D0%B3%D0%BE%D1%80%D0%B0%D1%85.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGeotop_Buckelwiesen_und_Dolinen_am_Gei%C3%9Fsch%C3%A4del_NE_von_Klais.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AUne_termiti%C3%A8re_07.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%94%D0%BE%D0%BC%D0%BE%D0%B2%D1%8B%D0%B9_%D1%81%D1%8B%D1%87._%D0%A1%D0%BE%D0%B2%D0%B0_%D0%B2_%D0%BA%D0%B0%D0%BD%D1%8C%D0%BE%D0%BD%D0%B5_%D1%83%D1%80%D0%BE%D1%87%D0%B8%D1%89%D0%B0_%D0%91%D0%BE%D0%B7%D0%B6%D1%8B%D1%80%D0%B0._01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMaltese_Honey_Bee_on_Blue_Stonecrop.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AOh_Deer.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APelikan_Divjake_Arben_Llapashtica.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D8%BA%D9%86%D8%A7%D8%A1_%D8%B7%D8%A7%D8%A6%D8%B1.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAlone_Nov24.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMona_pedra_do_bau-THIAGO_CAMPI-07.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AWhite-rumped_vulture_in_Chitwan_National_Park.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGroup_of_flying_storks.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGemination.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASunset_at_Poulnabrone_Dolmen_Co_Clare.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%E8%A7%A3%E8%BA%AB%E9%AB%94%E7%9A%84%E6%B8%B4.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMalabar_Parakeets_Cavorting.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASezibwa_Falls_Sunset.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%DA%A9%D9%88%D9%87_%D9%85%DB%8C%D8%B4%D9%88_%D8%AF%D8%A7%D8%BA%DB%8C_%DB%8C%DA%A9_%D8%B7%D8%A8%DB%8C%D8%B9%D8%AA_%D8%B2%DB%8C%D8%A8%D8%A7_%D9%88_%D8%B9%D8%A7%D9%84%DB%8C.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AEuplecte_varob%C3%A9_%C3%A0_Tanguieta.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AJengish_Chokusu_%28Victory_Peak%2C_Pik_Pobeda%29%2C_Southern_Inylchek_Glacier%2C_Tien_Shan_%E2%80%94_Golden_Hour.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9A%D1%83%D0%B4%D1%80%D1%8F%D0%B2%D1%8B%D0%B9_%D0%BF%D0%B5%D0%BB%D0%B8%D0%BA%D0%B0%D0%BD._%D0%9E%D0%B7%D0%B5%D1%80%D0%BE_%D0%9A%D0%B0%D1%80%D0%B0%D0%BA%D0%BE%D0%BB%D1%8C%2C_%D0%9C%D0%B0%D0%BD%D0%B3%D0%B8%D1%81%D1%82%D0%B0%D1%83.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AG%C3%B6pelschachtanlage_Naturschutzgebiet_Staatsbruch_Lehesten_IMGP7124_5_DxO_Sharp.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALes_hippopotames_de_la_rusizi.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGanoderme_luisant_ou_Ganoderma_lucidum_de_la_for%C3%AAt_d%27Abdoulaye_01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMarsovac.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGONLO_YA_mayi.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AModel_bees.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APaisajes_de_Ollantaytambo_20.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APantagonian_Mara.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APhasianus_colchicus_in_Tashkent_botanical_garden.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AZambia_Zimbabwe_Bridge.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFemale_Magnificent_Sunbird.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AHarlequin_tree_frog_%28Tabin_Wildlife_Reserve%2C_April_2025%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AUnderwater_Kiwi.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGaribaldi_Lake_at_dawn_on_New_Year%27s_Day%2C_2023.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AIxora_finlaysoniana_3.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABilad_Sayyit.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFilets_de_p%C3%AAche_el_Mallaha_Rad%C3%A8s.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThree_Irish_Red_Deer_at_Killarney_National_Park.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AZaqatala_D%C3%B6vl%C9%99t_T%C9%99bi%C9%99t_Qoru%C4%9Fu_%288%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AA_lion_resting_at_Dulahazra_Safari_Park%2C_Bangladesh.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGeotop_Wildflusslandschaft_Isartal_zwischen_Wallgau_und_Sylvensteinsee%2C_Vorderri%C3%9F_mit_Ri%C3%9Fbach_3.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D4%B1%D6%80%D5%A1%D5%A3%D5%A1%D5%AE%2C_%D4%B1%D5%BA%D5%A1%D6%80%D5%A1%D5%B6%D5%AB_%D5%BB%D6%80%D5%A1%D5%B4%D5%A2%D5%A1%D6%80.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACollection_time.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APhilippine_Pit_Viper.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AShwamp_deer.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%95%D1%80%D1%82%D0%B8%D1%81_%D0%BE%D1%80%D0%BC%D0%B0%D0%BD%D1%8B_%D0%B3%D1%83%D1%81%D0%B5%D0%BD%D0%B8%D1%86%D0%B0_%D0%BD%D0%B0_%D1%82%D1%80%D0%B0%D0%B2%D0%B5.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASpeckled_wood_%28Pararge_aegeria%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATarentola_gomerensis_in_tunisia_%28cropped%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AUpupa_epops_parents_arriving_with_food.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAerial_view_of_Bandar_Khayran_village%2C_Muscat%2C_Sultanate_of_Oman.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGreat_Cormorant_Struggling_for_Fish_at_Taudaha_Lake.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARayos_de_sol_al_amanecer_en_MachuPicchu.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%91%D0%B5%D0%BB%D1%8B%D0%B5_%D1%86%D0%B0%D0%BF%D0%BB%D0%B8._%D0%9E%D0%B7%D0%B5%D1%80%D0%BE_%D0%9A%D0%B0%D1%80%D0%B0%D0%BA%D0%BE%D0%BB%D1%8C._01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ANational_Park_%22Albanian_Alps%22%2C_Valbona.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AChute_d%27eau_de_laspati_%C3%A0_Hinche.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASpirostreptus_%C3%A0_Savalou.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%CE%9A%CE%B1%CE%BB%CF%8D%CE%B2%CE%B5%CF%82_%CF%88%CE%B1%CF%81%CE%AC%CE%B4%CF%89%CE%BD.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAl-Hala_island.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABopayBeach.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AWestern_cattle_egret_on_Lake_Sevan.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACatarata_Tarush_Yakunan.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3Alossy-page1-960px-Led%C5%88%C3%A1%C4%8Dek_%C5%99%C3%AD%C4%8Dn%C3%AD.tif.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMadygen_Sary-Tash_Valley_11.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMaralg%C3%B6l_20220730_%281%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALe_cerf_Tunisien.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABlack_henbane_on_Mount_Gutanasar.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMacroglossum_stellatarum%2C_Kalkara.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMaja_Stosic_-_Prskalo.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASculpted_Earth_of_Upper_Mustang.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%CE%98%CE%AD%CE%B1_%CF%83%CF%84%CE%B7_%CE%9B%CE%AF%CE%BC%CE%BD%CE%B7_%CE%A0%CE%BB%CE%B1%CF%83%CF%84%CE%AE%CF%81%CE%B1.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ADinaric_Alps%2C_view_from_Theth_-_Valbona_Pass.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFox_Pups_May_2025.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%2C%2CTam%2C_kde_ml%C4%8D%C3%AD_les_a_vl%C3%A1dne_mr%C3%A1z%E2%80%9C.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AOriental_%28_Crested_%29_Honey_Buzzard.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9B%D0%B8%D1%81%D0%B0_%D0%B2_%D0%90%D0%BA%D1%82%D0%B0%D1%83-%D0%91%D1%83%D0%B7%D0%B0%D1%87%D0%B8%D0%BD%D1%81%D0%BA%D0%BE%D0%BC_%D0%BF%D1%80%D0%B8%D1%80%D0%BE%D0%B4%D0%BD%D0%BE%D0%BC_%D0%B7%D0%B0%D0%BA%D0%B0%D0%B7%D0%BD%D0%B8%D0%BA%D0%B5._01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGalway_Bay_Swans_2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARastoke_-_Miro_Juri%C4%87.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASalt_Marsh%2C_North_of_Hayling_Island_2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFresh_Catch.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AA_aigle_2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%92%D0%BE%D0%B4%D0%BE%D0%BF%D0%B0%D0%B4_%D0%9F%D0%B0%D0%BB%D1%8C%D1%82%D0%B0%D1%83_%D0%B2_%D0%B0%D0%B2%D0%B3%D1%83%D1%81%D1%82%D0%B5.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAbbey_Hill.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ANature_of_Pirshagi_15.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AN%C3%A9nuphar_blanc_lac_Chitana.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARazorbills_on_Saltee.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_snake_keeper.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAn_Acrobatic_Feast%2C_Squirrel_Enjoying_Nectar.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AEl_abrigo_del_Tunari.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATowei_-_Kapchorwa_View.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D8%AD%D8%B1%D8%A8%D8%A7%D8%A1_%D8%B5%D8%AD%D8%B1%D8%A7%D9%88%D9%8A%D9%87.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AArabian_Gazels.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFlores%2C_Tarma_-_Per%C3%BA.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%E9%9D%92%E7%AB%B9%E7%B5%B2%E4%BC%91%E6%81%AF.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABee_on_a_Yellow_Salsify_12.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGrey_Heron_Landing_at_Ras_Al_Khoor.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AOwlet_drinks_from_lavender-_Gardunha_apr_2025.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_Guardian_24.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A001_Golden_jackal_and_azureum_flowers_in_Jim_Corbett_National_Park_Photo_by_Giles_Laurent.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABlue-cheeked.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A1%D0%BE%D0%B1%D0%B0%D0%BA%D0%B0_%D1%81%D0%BF%D0%B8%D1%82.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALasiommata_megera_butterfly_camouflaged_among_stones_and_dry_leaves.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AShpella_e_Radavcit_%284%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AValle_de_Ordesa_20250617-4.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALittle_tern_brids.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AParque_Estadual_do_Tainhas_Martin_Klippel_%2811%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A1%D1%80%D0%B5%D1%9B%D0%B0%D0%BD_%D0%BF%D1%83%D1%82.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABruco_di_Sfinge_dell%27Euforbia_9.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGeotop_Buckelwiesen_SE_von_Klais_-_im_Hintergrund_Schwarzkopf_%281592m%29_und_N%C3%B6rdliche_Karwendelkette.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APodi_i_Jakupit.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AEastern_Imperia_eagle.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASt%C3%A5ngehuvud_sunset.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AT%C3%B6rns%C3%A5ngare_i_ett_Solrosf%C3%A4lt_i_Biosf%C3%A4r_V%C3%A4nersk%C3%A4rg%C3%A5rden_med_Kinnekulle.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AIndian_white_eye.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKafue_River_Floodplain_Landscape_-_Zambia.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASwallows2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%22MAN_AND_NATURAL%22.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AABOVE_AND_BENEATH.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALamitye.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AZuma-Rock-near-Abuja-Nigeria.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AChampignons_qui_ont_pouss%C3%A9s_dans_dans_la_for%C3%AAt_de_malfakassa_13.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATheth%2C_2023.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%E6%9C%88%E5%A4%9C%E8%9F%AC%E8%81%B2%E9%80%80%E9%87%91%E8%A3%B3.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABlossom-headed_Parakeet_in_romantic_moments.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKarst_of_%22Mali_me_Gropa%22.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKastoria_lake_in_Autumn.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALorestan_1.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AModr%C3%A1_a_zlat%C3%A1%2C_v%C3%A1%C5%BEky_mot%C3%BDlice.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACascade%2C_Muniellos.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFishing_Net_and_Fisherman_2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AParque_Nacional_Marinho_de_Fernando_de_Noronha_-_Atoba_Pardo.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARiver_Densu_%40_Weija_dam_3.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKalo_Daha_Lake_of_Ruby_Valley.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AKiller_looks_of_the_Indian_Leopard.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ANigeria_Landscape_60.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGaze_of_the_Forest_Guardian.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARiver_Densu_%40_Weija_dam_2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALysa_Hora_tract%2C_on_the_southern_outskirts_of_the_Zhovtneva_Dacha_botanical_nature_monument.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALuntur_Jawa_Hutan_G.Kemulan.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APaisajes_de_Huilloc%2C_Ollantaytambo_17.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACurious_Snacker.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APICO_AUSTRIA.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AStoat_in_the_wild.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAraign%C3%A9e_verte_07.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALune_en_plein_plein_apr%C3%A8s-midi.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMating_Indian_leopards.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APskem_valley_from_Aynatash_rock_%28lower_reaches%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACannaiola_nel_canneto.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGiant_Doris_%28Felimare_or_Hypselodoris_picta_picta%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGlaciers_de_sel.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALe_Due_Sorelle_al_tramonto.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ANPB_Nacionalni_park_Plitvi%C4%8Dka_jezera_-Lika-Senj_B.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AStankaj.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AEl_Chorro_de_San_Luis_Waterfall_%E2%80%93_Protected_Area_in_Bolivia.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AVue_de_haut_sur_le_lieu_d%27abreuvage_am%C3%A9nag%C3%A9_pour_les_%C3%A9l%C3%A9phant_du_parc_malfakassa_et_fazao_03.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFulufj%C3%A4llets_Nationalpark.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_Mom.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AVinicunca_Mountains.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A002_Jabiru_feeding_its_babies_in_their_nest_in_Encontro_das_%C3%81guas_State_Park_Photo_by_Giles_Laurent.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ADouble_Euchloe_ausonia.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9E%D0%B7%D0%B5%D1%80%D0%BE_%D0%9A%D0%BE%D0%BB-%D0%A2%D0%BE%D1%80_%D0%BD%D0%B0_%D1%80%D0%B0%D1%81%D1%81%D0%B2%D0%B5%D1%82%D0%B5_%2C_%D0%90%D1%82-%D0%91%D0%B0%D1%88%D0%B8%D0%BD%D1%81%D0%BA%D0%B8%D0%B9_%D1%80%D0%B0%D0%B9%D0%BE%D0%BD%2C_%D0%9D%D0%B0%D1%80%D1%8B%D0%BD%D1%81%D0%BA%D0%B0%D1%8F_%D0%BE%D0%B1%D0%BB%D0%B0%D1%81%D1%82%D1%8C%2C%D0%9A%D1%8B%D1%80%D0%B3%D1%8B%D0%B7%D1%81%D1%82%D0%B0%D0%BD.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGrayling_butterfly1291.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%C3%81rea_de_Prote%C3%A7%C3%A3o_Ambiental_Marinha_do_Litoral_Norte_-_Jo%C3%A3o_DAndretta_%283%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABuffalo_Pose_in_Murchison_Falls_National_Park_01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_rise_of_the_scorpion.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAerial_view_of_Igboora.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APachyrhynchus_moniliferus.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AEntre_ciel_et_mer.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATa_Kalanka_Sea_Cave-1.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACercidocerus_lateralis.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMan_end_environment.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AStore_Mosse_Nationalpark_2023.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAn_Ant_Eating_a_Dead_Bengal_Monitor.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ADielli_mbi_hije%2C_Prevall%C3%AB_2024.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ANP08_Northern_Velebit_-_Lika-Senj_D.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ADolman_Giants_Ring_2010.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D9%85%D8%AD%D9%85%D9%8A%D8%A9_%D8%AC%D8%A8%D9%84_%D8%B9%D9%84%D8%A8%D8%A9_23.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFood_Passing_Kingfishers.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APm_1729224880278_cmp.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A018_Giant_otter_eating_a_fish_in_Encontro_das_%C3%81guas_State_Park_Photo_by_Giles_Laurent.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ANew_morph_Metapocyrtus_reyesi.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFarol_de_Sagres.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMar_de_Asas.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9A%D0%BE%D0%B2%D0%B0%D0%BB%D1%96%D0%B2%D1%81%D1%8C%D0%BA%D0%B8%D0%B9_%D0%AF%D1%80.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AHeuschrecke-JR-T20-I11-2024-07-31.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AYangMingShan_ChiaAnLin_002.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A4%D0%BB%D0%B0%D0%BC%D0%B8%D0%BD%D0%B3%D0%BE._%D0%9E%D0%B7%D0%B5%D1%80%D0%BE_%D0%9A%D0%B0%D1%80%D0%B0%D0%BA%D0%BE%D0%BB%D1%8C._01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A007_Asian_green_bee-eater_in_Jim_Corbett_National_Park_Photo_by_Giles_Laurent.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABurung_Mambruk.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALes_hauts_arbres_au_lac_des_oiseaux.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AValbona_Panoramike_01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAveiro_-_Black_redstart_chick.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AIsumo_nyakayi_yambere.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALesser_Kestrel_in_kuwait.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AVinicunca_subida.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAccumulation_de_d%C3%A9chets_en_milieu_urbain_%E2%80%93_Douala_-_3.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMountain_landscape_in_Khan_Tengri_Nature_Park%2C_Tien_Shan_-_Aerial_View.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%A1%D1%83%D0%BB%D0%B0%D0%B9%D0%BC%D0%B0%D0%BD-%D0%A2%D0%BE%D0%BE_%D1%81_%D0%B4%D1%80%D0%BE%D0%BD%D0%B0.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMaja_e_Rusolise.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AParqueNaturalRedes.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APicu_Urriellu_-_Mirador.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABothrops_bilineatus_PN_Carrasco.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFlamboyance_of_Flamingos_Al_Qudra_Lakes.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARollier_d%27Abyssinie_depuis_Tangui%C3%A9ta%2C_r%C3%A9gion_des_montagnes_Nord_B%C3%A9nin%2C_Janvier_2024.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATiger_Shambhu_with_a_huge_Kill.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATwilight_Gaze.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAerial_image_of_Tela%C5%A1%C4%87ica_Nature_Park_%28view_from_the_south%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAfrican_Wood_Owl_Portrait.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACarballo_de_H%C3%A4sselby_91.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APajcha.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APareja_de_carpinteros_andinos_%28yaca_yaca%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AStankaj%2C_Rugove.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAkanuma.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AEpicrates_cenchria%2C_Tipnis%2C_2025_02.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASource_cascade_de_Kpim%C3%A9_%C3%A0_Kpalim%C3%A9.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AVanneau_%C3%A0_%C3%A9perons%2C_photo_prise_%C3%A0_Tangui%C3%A9ta_en_F%C3%A9vrier_2024_au_Nord_B%C3%A9nin.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AR%C3%B6dstj%C3%A4rt_med_insekter_i_Biosf%C3%A4r_V%C3%A4nersk%C3%A4rg%C3%A5rden_med_Kinnekulle.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%97%D0%B0%D1%94%D1%86%D1%8C_%D1%81%D1%96%D1%80%D0%B8%D0%B9_%D1%83_%D0%BF%D0%BE%D0%BB%D1%96.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACharr%C3%A1n_com%C3%BAn_con_pez.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AROE_DEER%2C_Capreolus_capreolus_-_R%C3%85DJUR.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9D%D0%B0%D1%86%D1%96%D0%BE%D0%BD%D0%B0%D0%BB%D1%8C%D0%BD%D0%B8%D0%B9_%D0%BF%D0%B0%D1%80%D0%BA_%D0%9F%D0%BB%D1%96%D1%82%D0%B2%D1%96%D1%86%D1%8C%D0%BA%D1%96_%D0%BE%D0%B7%D0%B5%D1%80%D0%B0_%28%D0%A5%D0%BE%D1%80%D0%B2%D0%B0%D1%82%D1%96%D1%8F%29_20.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AVerdurE.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%92%D1%83%D0%B6_%D0%B2%D0%BE%D0%B4%D1%8F%D0%BD%D0%B8%D0%B9_%D0%B7%D1%96_%D0%B7%D0%B4%D0%BE%D0%B1%D0%B8%D1%87%D1%87%D1%8E1.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D4%B3%D5%B8%D5%B4%D5%A2%D5%A1%D5%AF_24.05.2025_DSC_9523_01.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACinco_Lagunas%2C_Sierra_de_Guadarrama.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACommon_kingfisher_in_sunrise_with_breakfast.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMount_Tufanda%C4%9F.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AOrang_Utan_Sumatra_dan_anaknya.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AL%27antilope.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMille-pattes_g%C3%A9ant_en_d%C3%A9placement_sur_l%E2%80%99humus_forestier_02.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABombus_monozonus_and_Rhododendron_rubropilosum_near_Mount_Xiaobajian.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AReflexos_da_Tranquilidade_%28Ria_Aveiro%29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARiflesso_delle_Pale_di_San_Martino.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_Dervish.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ADead_bird_baby_tried_to_swallow_plastic.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARed-winged_Lark_in_Pian_Upe.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D8%B1%D9%88%D8%A8%D8%A7%D9%87_%D8%AF%D8%B1_%D9%BE%D8%A7%D8%B1%DA%A9_%D9%85%D9%84%DB%8C_%D8%AA%D9%86%D8%AF%D9%88%D8%B1%D9%87.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATausendgueldenkraut-JR-T20-I71-2024-07-22.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMacizo_del_Corni%C3%B2n.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMir%C3%ABdit%C3%AB_-_Shqip%C3%ABri.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ARed_mountains_Khizy_1.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASandrippel_im_Sonnenuntergang_06.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AShey-Phoksundo_Lake_in_Dolpa.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D8%AD%D8%A7%D8%B1%D8%B3_%D8%A7%D9%84%D8%B5%D8%AD%D8%B1%D8%A7%D8%A1.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACivette_29.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALaguna_Mullaca%2C_ruta_de_las_cuatro_lagunas_03.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AHigh_Cup_Nick_Panorama.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AOmiljeno_mjesto.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASpeckled_bush-cricket.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFagus_sylvatica_with_autumn_leaf_color_in_Biosph%C3%A4renreservat_Rh%C3%B6n_-_Still.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AIl-Kantra_Valley%2C_Gozo.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D9%BE%DB%8C%D8%B1%D8%A7%D8%B3%D9%85%D8%A7%D8%B9%DB%8C%D9%84_%D8%A8%D8%A7%D9%84%D8%A7_%D8%AA%D8%B1%D8%AE%DB%8C%D9%86%E2%80%8C%D8%A2%D8%A8%D8%A7%D8%AF.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ATowei_Highlands_2.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AOriental_Pied_Hornbill_-_Pangkor.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AStand_of_Beeches.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AWater_splash_in_Kingfisher.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%97%D0%B0%D0%BF%D0%BE%D0%B2%D0%B5%D0%B4%D0%BD%D0%B8%D0%BA_%D0%A1%D0%B0%D1%80%D1%8B-%D0%A7%D0%B5%D0%BB%D0%B5%D0%BA_%D0%A4%D0%BE%D1%82%D0%BE_%D0%9E%D0%B7%D0%B5%D1%80_%D1%81_%D0%BF%D0%B0%D0%BD%D0%BE%D1%80%D0%B0%D0%BC%D1%8B.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AL%27%C3%AElet_de_Grand-Go%C3%A2ve.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_Canap%C3%A9_Vert_Forest.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%9E%D1%81%D1%82%D1%80%D1%96%D0%B2_%D0%B2_%D0%BF%D0%B0%D1%80%D0%BA%D1%83_%D0%A1%D0%BE%D1%84%D1%96%D1%97%D0%B2%D0%BA%D0%B0.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAerial_View_of_Peaks_of_Khumbu%2C_Ngozumpa_Glacier_and_Gokyo_Lakes.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AJaga_Kami_Agar_Tetap_Lestari.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APanoramic_View_of_Oke-Ila_Orangun_Landscape_near_Ayikunugba_Waterfall.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASunflower_Serenade%2C_A_Parakeet%27s_Delight.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ABarn_swallow_taking_a_bath.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ADilijan_National_Park_near_Mount_Dimats_in_autumn.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AOvejas_latxa_en_Sierra_Gibijo_02.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ASulaibikhat_District.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D4%B1%D6%80%D5%A1%D5%A3%D5%A1%D5%AE%D5%B8%D5%BF%D5%B6%E2%80%A4%D4%B1%D5%BA%D5%A1%D6%80%D5%A1%D5%B6%D5%AB_%D5%BB%D6%80%D5%A1%D5%B4%D5%A2%D5%A1%D6%80.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AGazelle_at_Sunset.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALiqeni_i_Shutmanit_%28Shutman_Lake%29_Sharr_Mountains.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APied_king_fisher.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALac_Rwihinda%2C_sanctuaire_naturel_des_oiseaux_%C3%A0_kirundo.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ACHKO_Brdy_V%C3%A1%C5%BEka_%C4%8D%C3%A1rkovan%C3%A1-Tok.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AJezerca_Peak.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AThe_Rockies_of_Bolinao.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D0%94%D0%BE%D0%BC%D0%BE%D0%B2%D1%8B%D0%B9_%D1%81%D1%8B%D1%87._%D0%A1%D0%BE%D0%B2%D1%8B_%D0%B2_%D0%BA%D0%B0%D0%BD%D1%8C%D0%BE%D0%BD%D0%B5_%D1%83%D1%80%D0%BE%D1%87%D0%B8%D1%89%D0%B0_%D0%91%D0%BE%D0%B7%D0%B6%D1%8B%D1%80%D0%B0._04.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A008_Eurasian_hoopoe_eating_in_Keoladeo_National_Park_Photo_by_Giles_Laurent.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AFlock_of_sheep_in_the_Sharr_Mountains_1.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3ALastiver_Waterfall.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMaglovito_jutro_iznad_Dunava.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3APhilaeus_chrysops_in_Khoja_Gur_Gur_Ota_215.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AProtective_Embrace.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A%D4%BB%D5%BB%D6%87%D5%A1%D5%B6%D5%AB_%D5%A1%D6%80%D5%A3%D5%A5%D5%AC%D5%A1%D5%BE%D5%A1%D5%B5%D6%80.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3A019_Anhinga_eating_a_fish_in_Encontro_das_%C3%81guas_State_Park_Photo_by_Giles_Laurent.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AMisty_Morning_in_bromo.jpg
https://commons.wikimedia.org/wiki/Commons:Wiki_Loves_Earth_2025/Winners#/media/File%3AAxios_Delta_Sunrise.jpg
EOF
)

# --- 3. VÉLETLENSZERŰ VÁLASZTÁS ÉS DEKÓDOLÁS ---
RANDOM_URL=$(echo "$URL_LIST" | grep -v '^\s*$' | shuf -n 1)
# Kinyerjük a nyers, esetenként kódolt fájlnevet
RAW_FILENAME=$(echo "$RANDOM_URL" | grep -oP 'File(%3A|:)\K.*')

if [ -z "$RAW_FILENAME" ]; then
  feh --bg-fill "$DEFAULT_IMG"
  exit 1
fi

# !!! A JAVÍTÁS ITT VAN !!!
# URL kódolás visszafejtése (pl. %28 -> (, %20 -> szóköz) az API lekérdezéshez
DECODED_FILENAME=$(printf '%b' "${RAW_FILENAME//%/\\x}")

# --- 4. API LEKÉRDEZÉS (Metaadatok) ---
# Itt már a tiszta, emberi olvasásra alkalmas nevet (DECODED_FILENAME) adjuk át
RESPONSE=$(curl -s -G "$API_URL" \
  --data-urlencode "action=query" \
  --data-urlencode "format=json" \
  --data-urlencode "prop=imageinfo" \
  --data-urlencode "iiprop=extmetadata|user" \
  --data-urlencode "titles=File:$DECODED_FILENAME")

# Adatok kinyerése
AUTHOR=$(echo "$RESPONSE" | jq -r '.query.pages[].imageinfo[0].extmetadata.Artist.value // "Ismeretlen"' | sed 's/<[^>]*>//g')
LICENSE=$(echo "$RESPONSE" | jq -r '.query.pages[].imageinfo[0].extmetadata.LicenseShortName.value // "n.a."')
DESCRIPTION=$(echo "$RESPONSE" | jq -r '.query.pages[].imageinfo[0].extmetadata.ImageDescription.value // "Nincs leírás"' | sed 's/<[^>]*>//g' | head -c 100)
CAMERA=$(echo "$RESPONSE" | jq -r '.query.pages[].imageinfo[0].extmetadata.Model.value // "Ismeretlen gép"')

# --- 5. LETÖLTÉS ÉS BEÁLLÍTÁS ---
# A letöltéshez (wget) marad a RAW változat, mert a szerverek azt szeretik
DIRECT_URL="https://commons.wikimedia.org/wiki/Special:FilePath/${RAW_FILENAME}?width=${RESOLUTION_WIDTH}"

if wget -q -O "$TMP_IMG" "$DIRECT_URL"; then
  feh --bg-fill "$TMP_IMG"

  # --- 6. MENTÉS A TMP FÁJLBA ---
  {
    echo "=== JELENLEGI HÁTTÉRKÉP ==="
    echo "Cím: $DECODED_FILENAME"
    echo "Szerző: $AUTHOR"
    echo "Licenc: $LICENSE"
    echo "Kamera: $CAMERA"
    echo "Leírás: $DESCRIPTION..."
    # Opcionálisan kicseréljük a szóközöket aláhúzásra, hogy kattintható maradjon a terminálban
    echo "Link: https://commons.wikimedia.org/wiki/File:${DECODED_FILENAME// /_}"
    echo "Dátum: $(date '+%Y-%m-%d %H:%M:%S')"
  } >"$INFO_FILE"

  # --- 7. ÉRTESÍTÉS ---
  # notify-send -u normal "Új háttérkép beállítva" "📷 $AUTHOR\n⚙️ $CAMERA\n⚖️ $LICENSE" -i "$TMP_IMG"
else
  feh --bg-fill "$DEFAULT_IMG"
  echo "Hiba a letöltés során." >"$INFO_FILE"
fi
