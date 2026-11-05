## Title: Custom species

aka Frankensteining body parts onto bodies in a more sustainable way. Hopefully.

### Description:

Groundwork for collapsing Nova's many cosmetic species into one customizable species, where players pick their
body parts per limb, and species mechanics (breathing, blood, special organs) come from heritage quirks.

What's in here so far:

- **Heritage** (`code/heritage.dm`): a lore species id stored in DNA (`FEATURE_HERITAGE`). Species with `uses_heritage`
  make `is_species()` / `ishumanbasic()` treat the mob as its heritage's legacy species, so existing `isvox()` style checks keep working.
- **Species presets** (`code/species_preset.dm`): `/datum/species_preset`, the bundle that replaces an old species. Its `id` is the old species id.
- **Heritage quirks** (`code/heritage_quirks/_heritage.dm`): the `heritage_quirk` flag, and `/datum/quirk/heritage` base that grants traits,
  organs and blood type, and keeps them through species changes and organ regeneration.

Related, outside this module:

- Clothing sprites for BODYSHAPE_CUSTOM limbs (vox, teshari) moved from the species to the bodypart. See `/datum/custom_bodytype`
  in `modular_nova/modules/customization/modules/mob/living/carbon/human/custom_bodytype.dm` and `/obj/item/bodypart/var/custom_bodytype`.

### TG Proc Changes:

- `code/__HELPERS/mobs.dm`: `is_species()`, `ishumanbasic()` - also check heritage.
- `code/modules/mob/living/carbon/human/human_update_icons.dm`: custom worn icons come from `/mob/living/carbon/human/proc/generate_custom_worn_icon()` instead of the species.
- `code/modules/client/preferences/middleware/quirks.dm`: sends `heritage_quirk` to the UI.

### Defines:

- `FEATURE_HERITAGE` in `code/__DEFINES/~nova_defines/DNA.dm`

### Other important files:

- `tgui/packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/QuirksPage.tsx`, `types.ts`, `styles/interfaces/PreferencesMenu.scss` - heritage quirk color.
