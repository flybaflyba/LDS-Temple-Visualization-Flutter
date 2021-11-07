# spiral_vis

Spiral Visualization for LDS temples - Flutter Version

- [Android version](https://github.com/flybaflyba/LDS-Temple-Visualization)
- [iOS version](https://github.com/flybaflyba/LDS-Temple-Visualization-IOS)

## LDS Temple Visualization in Flutter

- Easier maintenance
- Identical iOS and Android versions
- Web supported! 

## About

- [App website - Chinese](https://latterdaytemples.litianzhang.com/home-chinese/)
- [App website - English](https://latterdaytemples.litianzhang.com/)
- [Church website - Chinese](https://www.churchofjesuschrist.org/?lang=zho)
- [Church website - English](https://www.churchofjesuschrist.org/?lang=eng)
- [School website](https://www.byuh.edu/)
- [Professor website](https://geoffdraper.com/)
- [Student website - Chinese](https://litianzhang.com/zh/home-2/)
- [Student website -English](https://litianzhang.com/)

## Maintenance Instruction (No code change needed)

### Add new temples

 - [Required] Add new temple name in assets/texts/names_and_years.txt, 0000 means under construction, 1111 means announced. Usually you will just need to use 1111 since adding new temples are for newly announced temples.
 - [Optional] Add temple images cropped in assets/large_circles and assets/small_circles, the file name should match the one in names_and_years file name part. Refer to other images in the folders for image sizes you should use, this is not a must, but too large image files will impact app performance. 
 - [Optional] Add milestone dates file in assets/infos, the file name should match the same way as the last step. If no info file added for a temple, "No Info Found" text will display to end users. Refer to other info files for data consistency. 
 
### Adjusting existing temples

 - Adjust temple orders in assets/texts/name_and_years.txt, make sure to change the year part.
 - If the milestone dates changed, for example, a temple started construction, or was dedicated, find it's corresponding info file in assets/infos, and change it. 
 - If a temple image becomes available, or you just want to change the temple image, then replace the old ones in assets/large_circles and assets/small_circles, we use the same image for both just different size to be consistent in user view, but using different image will not causing bugs. 
   
### Adding new features or adding existing features

 - Welcome to modify the code! Make sure you commit and push regularly if you ever need or want to revert back! 