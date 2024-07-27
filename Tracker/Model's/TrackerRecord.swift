//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Александра Коснырева on 11.07.2024.
//

import Foundation
struct TrackerRecord: Hashable {
    let id: UUID
    let date: Date
}
//сущность для хранения записи о том, что некий трекер был выполнен на некоторую дату; хранит id трекера, который был выполнен и дату. То есть, когда пользователь нажимает на + в ячейке трекера, мы создаём новую запись TrackerRecord — туда и запоминаем, какой трекер был выполнен в выбранную дату.