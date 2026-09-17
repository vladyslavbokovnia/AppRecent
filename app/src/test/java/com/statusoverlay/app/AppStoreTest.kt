package com.statusoverlay.app

import org.junit.Assert.assertEquals
import org.junit.Test

class AppStoreLogicTest {
    @Test fun manualOrderMovesItemOnePositionBack() {
        val original = listOf("one", "two", "three")
        val index = original.indexOf("three")
        val changed = original.toMutableList().apply { add(index - 1, removeAt(index)) }
        assertEquals(listOf("one", "three", "two"), changed)
    }
}
