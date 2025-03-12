package com.hj.controller;

import com.hj.service.AttachFileService;
import com.hj.service.FoodService;
import com.hj.vo.FoodVo;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/food")
public class FoodController {
    Logger log = LoggerFactory.getLogger(FoodController.class);

    @Resource(name="foodService")
    private FoodService foodService;

    @GetMapping("/")
    public String food(Model model) {
        List<FoodVo> foodVoList = this.foodService.selectAll();
        model.addAttribute("foodVoList", foodVoList);
        return "food/menu";
    }

    @PostMapping("/update")
    @ResponseBody
    public String update(@RequestBody Map<String, Object> data) {
        for (Map.Entry<String, Object> entry : data.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue().toString();

            FoodVo foodVo = new FoodVo();
            foodVo.setMealDate(LocalDate.parse(key));
            foodVo.setMeal(value.replaceAll("\n", "<br>"));

            this.foodService.update(foodVo);
        }
        return "success";
    }

    @GetMapping("/download")
    public ResponseEntity<byte[]> download(@RequestParam String yearMonth) {
        List<FoodVo> foodVoList = this.foodService.selectByYearMonth(yearMonth);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("식단표");

        Row headerRow = sheet.createRow(0);
        String[] headers = {"날짜", "식단"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
        }

        int rowNum = 1;
        for (FoodVo food : foodVoList) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(food.getMealDate());
            row.createCell(1).setCellValue(food.getMeal());
        }

        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        try {
            workbook.write(outputStream);
            workbook.close();
        } catch (IOException e) {
            log.error(e.getMessage());
        }

        byte[] excelData = outputStream.toByteArray();

        HttpHeaders headersMap = new HttpHeaders();
        headersMap.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=식단표.xlsx");

        return ResponseEntity.ok()
                .headers(headersMap)
                .body(excelData);
    }
}
