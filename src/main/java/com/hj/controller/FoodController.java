package com.hj.controller;

import com.hj.service.AttachFileService;
import com.hj.service.FoodService;
import com.hj.vo.FoodVo;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
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
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
    public ResponseEntity<byte[]> download(@RequestParam String year, String month) {
        if(month.length() < 2) month = "0" + month;
        String yearMonth = year + "-" + month;
        List<FoodVo> foodVoList = this.foodService.selectByYearMonth(yearMonth);
        Map<LocalDate, String> foodVoMap = foodVoList.stream()
                .collect(Collectors.toMap(
                        FoodVo::getMealDate,
                        FoodVo::getMeal
                ));

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("식단표");

        CellStyle titleStyle = workbook.createCellStyle();
        Font titleFont = workbook.createFont();
        titleFont.setFontHeightInPoints((short) 50);
        titleFont.setBold(true);
        titleStyle.setFont(titleFont);
        titleStyle.setBorderTop(BorderStyle.THIN);
        titleStyle.setBorderBottom(BorderStyle.THIN);
        titleStyle.setBorderLeft(BorderStyle.THIN);
        titleStyle.setBorderRight(BorderStyle.THIN);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);

        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);

        CellStyle contentStyle = workbook.createCellStyle();
        contentStyle.setBorderTop(BorderStyle.THIN);
        contentStyle.setBorderBottom(BorderStyle.THIN);
        contentStyle.setBorderLeft(BorderStyle.THIN);
        contentStyle.setBorderRight(BorderStyle.THIN);
        contentStyle.setAlignment(HorizontalAlignment.CENTER);
        contentStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        contentStyle.setWrapText(true);

        Row titleRow = sheet.createRow(1);
        Cell titleCell = titleRow.createCell(1);
        titleCell.setCellValue(year + "년 " + month + "월 식단표");
        titleCell.setCellStyle(titleStyle);
        for(int i=2; i<=7; i++){
            titleRow.createCell(i).setCellStyle(titleStyle);
        }
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 1, 7));

        String[] headers = {"일", "월", "화", "수", "목", "금", "토"};
        Row headerRow = sheet.createRow(2);
        for(int i = 0; i < headers.length; i++) {
            sheet.setColumnWidth(i+1, 20 * 256);  // 20자 정도의 너비로 설정
            Cell headerCell = headerRow.createCell(i+1);
            headerCell.setCellValue(headers[i]);
            headerCell.setCellStyle(headerStyle);
        }

        LocalDate date = LocalDate.parse(yearMonth+"-01");
        int firstDayOfWeek = date.getDayOfWeek().getValue() % 7; // sun:0 mon: 1 ... sat: 6
        int lengthOfMonth = date.lengthOfMonth();
        int rowNum = 3;
        int idx = 0;
        Row dateRow = sheet.createRow(rowNum++);
        Row mealRow = sheet.createRow(rowNum++);
        while (idx < lengthOfMonth) {
            if((firstDayOfWeek + 1 + idx) % 7 == 1) {
                dateRow = sheet.createRow(rowNum++);
                mealRow = sheet.createRow(rowNum++);
            }
            int cellIdx = (firstDayOfWeek + 1 + idx) % 7;
            if(cellIdx == 0)    cellIdx = 7;

            Cell dateCell = dateRow.createCell(cellIdx);
            dateCell.setCellValue(idx + 1);
            dateCell.setCellStyle(contentStyle);

            Cell mealCell = mealRow.createCell(cellIdx);
            String mealDate = (idx+1) < 10 ? yearMonth + "-0" + (idx+1) : yearMonth + "-" + (idx+1);
            String menu = foodVoMap.get(LocalDate.parse(mealDate));
            if(menu != null) {
                mealCell.setCellValue(menu.replaceAll("<br>", "\n"));
            }
            mealCell.setCellStyle(contentStyle);

            idx++;
        }

        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        try {
            workbook.write(outputStream);
            workbook.close();
        } catch (IOException e) {
            log.error(e.getMessage());
        }

        byte[] excelData = outputStream.toByteArray();

        // **한글 파일명을 UTF-8로 인코딩**
        String filename = "식단표.xlsx";
        String encodedFilename = null;
        try {
            encodedFilename = URLEncoder.encode(filename, String.valueOf(StandardCharsets.UTF_8)).replaceAll("\\+", "%20");
        } catch (UnsupportedEncodingException e) {
            log.error(e.getMessage());
        }

        HttpHeaders headersMap = new HttpHeaders();
        headersMap.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename*=UTF-8''" + encodedFilename);

        return ResponseEntity.ok()
                .headers(headersMap)
                .body(excelData);
    }
}
