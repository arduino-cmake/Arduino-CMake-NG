#include "LiquidCrystalTest.hpp"

LiquidCrystal_I2C lcd(LCD_ADDRESS, LCD_COLUMNS, LCD_ROWS);

void testLiquidCrystal()
{
    lcd.begin(LCD_COLUMNS, LCD_ROWS);
    lcd.clear();
}
